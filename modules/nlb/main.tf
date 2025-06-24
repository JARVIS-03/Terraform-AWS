resource "aws_lb" "nlb" {
  name               = "${var.project}-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.project}-nlb"
  }
}


resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.project}-nlb-tg"
  port        = 80
  protocol    = "TCP" # NLB uses TCP
  vpc_id      = var.vpc_id
  target_type = "ip" # or "alb" if using ALB IPs

  health_check {
    port                = "80"
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
  }
}


resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

