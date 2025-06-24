resource "aws_lb" "alb" {
  name               = "${var.project}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

    tags = {
    Name = "${var.project}-alb"
  }
}

# A-LB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

 ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

# resource "aws_lb_target_group" "this" {
#   name        = "${var.project}-tg"
#   port        = 8083
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"
#   health_check {
#     path                = "/actuator/health"
#     startPeriod         = 90
#     interval            = 90
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
#    tags = {
#     Name = "${var.project}-tg"
#   }
# }

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

 
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}


