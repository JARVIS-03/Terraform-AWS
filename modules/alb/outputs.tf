output "alb_dns_name" {
  description = "Outputs the DNS of the ALB"
  value = aws_lb.alb.dns_name
}


output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_arn" {
  description = "Gives the ARN of the ALB"
  value = aws_lb.alb.arn
}

# output "target_group_arn" {
#   description = "ECS service to register tasks with target group"
#   value = aws_lb_target_group.this.arn
# }

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.http.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

