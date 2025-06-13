resource "aws_lb" "nlb" {
  name               = "${var.project}-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.project}-nlb-tg"
  port        = 80
  protocol    = "TCP" # NLB uses TCP
  vpc_id      = var.vpc_id
  target_type = "ip" # or "alb" if using ALB IPs
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

