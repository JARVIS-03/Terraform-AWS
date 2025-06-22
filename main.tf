provider "aws" {
  region = var.aws_region
  access_key              = var.aws_access_key
  secret_key              = var.aws_secret_key
}

#VPC Module Config:
module "vpc" {
  source           = "./modules/vpc"
  project          = var.project
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
  nat_gateway_ids       = module.nat_gateway.nat_gateway_ids
}

#NAT Gateway Module Config:
module "nat_gateway" {
  source            = "./modules/nat_gateway"
  project = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  igw_id = module.vpc.igw_id
}

#N-LB Module Config:
module "nlb" {
  source     = "./modules/nlb"
  project    = var.project
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  alb_dns_name = module.alb.alb_dns_name

}

#A-LB Module Config:
module "alb" {
  source      = "./modules/alb"
  project     = var.project
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
}

#ECS Cluster Module Config:
module "ecs_clusters" {
  source             = "./modules/ecs_clusters"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids 
  alb_listener_arn   = module.alb.listener_arn
  alb_sg_id = module.alb.alb_sg_id
  aws_region = var.aws_region
  db_host = module.rds.rds_endpoint
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password


  services = {
    payment = {
      container_name = "payment-service"
      container_port = 8083
      cpu            = 256
      memory         = 512
      desired_count  = 2
      image          = "${var.ecr_image}"
      health_path    = "/actuator/health"
    }
  }
}


#RDS Module Config:
module "rds" {
  source = "./modules/rds"

  project         = var.project
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  db_instance_class = var.db_instance_class
  ecs_service_sg_id  = module.ecs_clusters.ecs_service_sg_id
}

#Route 53 Config:
module "route53" {
  source = "./modules/route53"

  domain_name     = var.domain_name
  record_name = var.record_name
  nlb_dns_name = module.nlb.nlb_dns_name
  nlb_zone_id  = module.nlb.nlb_zone_id
}



