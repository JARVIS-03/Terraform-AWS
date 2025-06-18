resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8082
    to_port         = 8082
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  service_list = [for k, v in var.services : {
    name          = k
    container     = v.container_name
    port          = v.container_port
    cpu           = v.cpu
    memory        = v.memory
    desired_count = v.desired_count
    image         = v.image
    health_path   = v.health_path
  }]
}

resource "aws_ecs_task_definition" "this" {
  for_each = { for svc in local.service_list : svc.name => svc }

  family                   = "${var.project}-${each.key}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = each.value.container
    image = each.value.image
    portMappings = [{
      containerPort = each.value.port
      hostPort      = each.value.port
    }]
    environment = [
      {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "prod"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = aws_cloudwatch_log_group.log_group.name,
        awslogs-region        = var.aws_region,
        awslogs-stream-prefix = "ecs"
      }
    }
    essential = true
  }])
}

# resource "aws_lb_target_group" "this" {
#   for_each = { for svc in local.service_list : svc.name => svc }
#
#   name        = "${var.project}-${each.key}-tg"
#   port        = each.value.port
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"
#
#   health_check {
#     path                = each.value.health_path
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }

# resource "aws_lb_listener_rule" "this" {
#   for_each = { for svc in local.service_list : svc.name => svc }
#
#   listener_arn = var.alb_listener_arn
#
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this[each.key].arn
#   }
#
#   condition {
#     path_pattern {
#       values = ["/${each.key}*"]
#     }
#   }
# }

resource "aws_ecs_service" "this" {
  for_each = { for svc in local.service_list : svc.name => svc }

  name            = "${var.project}-${each.key}-svc"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = each.value.desired_count
  task_definition = aws_ecs_task_definition.this[each.key].arn

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id] # <-- Replace with actual variable or value
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_arn
    container_name   = each.value.container
    container_port   = each.value.port
  }

  depends_on = [
    var.alb_listener,
    aws_iam_role_policy_attachment.ecs_task_execution_attach
  ]
}


resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${var.project}-log_group"
  retention_in_days = 7
}
