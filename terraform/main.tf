# TERRAFORM
terraform {
  backend "s3" {
    bucket         = "gila-terraform-remote-state"
    key            = "live/docs/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-remote-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-3"
}

# NETWORK
variable "show_ip" {
  type        = bool
  description = "shows the public ip"
  default     = false
}

# NETWORK
data "aws_network_interface" "list" {
  count = var.show_ip ? 1 : 0
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "docs_sg" {
  name = "docs_sg"
}

resource "aws_security_group_rule" "allow_https_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.docs_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.docs_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# IAM
data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

#ECR and ECS
resource "aws_ecr_repository" "img_repo" {
  name                 = "cashier-docs"
  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecs_cluster" "sense_eight" {
  name = "sense-eight"
}

data "template_file" "user_data" {
  template = file("task-definitions/service.json")
  vars = {
    ecr_img = aws_ecr_repository.img_repo.repository_url
  }
}

resource "aws_ecs_task_definition" "docs_task" {
  family                   = "ecs-docs"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn
  container_definitions    = data.template_file.user_data.rendered
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "ecs_docs" {
  name            = "ecs-docs"
  task_definition = aws_ecs_task_definition.docs_task.arn
  cluster         = aws_ecs_cluster.sense_eight.id
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip = true
    subnets          = data.aws_subnet_ids.default.ids
    security_groups  = [aws_security_group.docs_sg.id]
  }
  desired_count = 1
}

output "repo" {
  value = aws_ecr_repository.img_repo.repository_url
}

output "access" {
  value = <<EOF
%{~for interface in data.aws_network_interface.list}
  ${interface.association[0].public_ip}
  ${interface.association[0].public_dns_name}
%{~endfor}
EOF
}
output "container_definition" {
  value = aws_ecs_task_definition.docs_task
}
