

#ECS Output
output "ecs_cluster_id" {
  value = module.ecs_clusters.ecs_cluster_id
}

output "ecs_services" {
  value = module.ecs_clusters.ecs_services
}

#RDS Output
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_sg_id" {
  value = module.rds.rds_sg_id
}

#VPC Output
output "vpc_id" {
  value = module.vpc.vpc_id
}

#N-LB Output
output "nlb_dns_name" {
  value = module.nlb.nlb_dns_name
}

#A-LB Output
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}


#Route 53 Output
output "domain_record" {
  value = module.route53.route53_record_fqdn
}

