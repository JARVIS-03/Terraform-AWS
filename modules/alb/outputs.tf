output "alb_dns_name" {
  description = "Outputs the DNS of the ALB"
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "Gives the ARN of the ALB"
  value = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "ECS service to register tasks with target group"
  value = aws_lb_target_group.app_tg.arn
}

output "listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.http.arn
}
