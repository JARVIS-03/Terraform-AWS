resource "aws_lb" "nlb" {
  name               = "${var.project}-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.subnet_ids
}

# resource "aws_lb_listener" "tcp" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = 443
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }
# }
