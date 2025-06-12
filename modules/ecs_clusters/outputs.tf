output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_services" {
  value = { for svc, res in aws_ecs_service.this : svc => res.name }
}

output "task_definition_arns" {
  value = { for svc, def in aws_ecs_task_definition.this : svc => def.arn }
}

output "target_group_arns" {
  value = { for svc, tg in aws_lb_target_group.this : svc => tg.arn }
}