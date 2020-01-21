provider "aws" {
  region = "eu-west-3"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "alb" {
  name = "ecs-sg-alb"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "container" {
  name = "container-sg"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_container_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.container.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb_target_group" "ecs" {
  name     = "ecs-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "ecs" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb" "balancer" {
  name               = "ecs-elb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_ecr_repository" "img_repo" {
  name                 = "docs"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "sense_eight" {
  name = "sense-eight"
}

resource "aws_ecs_task_definition" "docs_task" {
  family                = "docs"
  container_definitions = file("task-definitions/service.json")
}

resource "aws_ecs_service" "ecs_docs" {
  name = "ecs-docs"

  task_definition = aws_ecs_task_definition.docs_task.arn
  cluster         = aws_ecs_cluster.sense_eight.id

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "cashier-docs"
    container_port   = 8080
  }

  desired_count = 1
}
output "balancer" {
  value = aws_lb.balancer
}
