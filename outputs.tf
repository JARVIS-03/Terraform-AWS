

#ECS Output
output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "ecs_services" {
  value = module.ecs.ecs_services
}

#RDS Output
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_sg_id" {
  value = module.rds.rds_sg_id
}
