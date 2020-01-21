provider "aws" {
  region = "eu-west-3"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_ecr_repository" "img_repo" {

  name                 = "cashier-docs"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_security_group" "docs_sg" {
  name = "docs_sg"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.docs_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.docs_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_ecs_cluster" "sense_eight" {
  name = "sense-eight"
}

data "template_file" "user_data" {
  template = file("task-definitions/service.json")
  vars = {
    registry_url = aws_ecr_repository.img_repo.repository_url


  }
}

data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "docs_task" {
  family                   = "cashier-docs"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn
  container_definitions    = data.template_file.user_data.rendered

  cpu    = 256
  memory = 512

}

resource "aws_ecs_service" "ecs_docs" {
  name = "ecs-docs"

  task_definition = aws_ecs_task_definition.docs_task.arn
  cluster         = aws_ecs_cluster.sense_eight.id

  launch_type = "FARGATE"
  network_configuration {

    assign_public_ip = true
    subnets          = data.aws_subnet_ids.default.ids
    security_groups  = [aws_security_group.docs_sg.id]
  }

  desired_count = 1
}

output "registry" {
  value = aws_ecr_repository.img_repo.repository_url
}
