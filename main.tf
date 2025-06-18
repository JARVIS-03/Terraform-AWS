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
  nat_gateway_ids = module.nat_gateway.nat_gateway_ids
}

#NAT Gateway Module Config:
module "nat_gateway" {
  source            = "./modules/nat_gateway"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

#N-LB Module Config:
module "nlb" {
  source     = "./modules/nlb"
  project    = var.project
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
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
  ecr_image = var.ecr_image
  alb_sg_id = module.alb.alb_security_grp_id
  alb_target_arn=module.alb.target_group_arn
  alb_listener = module.alb.listener
  services = {
    payment = {
      container_name = "payment-service"
      container_port = 8082
      cpu            = 256
      memory         = 512
      desired_count  = 2
      image          = "public.ecr.aws/i1v2i8s3/order-service"
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

  db_name         = "ecomdb"
  db_username     = var.db_username
  db_password     = var.db_password
  db_instance_class = "db.t3.micro"
  ecs_sg_id = module.ecs_clusters.ecs_security_grp_id
}

#Route 53 Config:
module "route53" {
  source = "./modules/route53"

  domain_name     = var.domain_name
  nlb_dns_name = module.nlb.nlb_dns_name
  zone_id = var.hosted_zone_id
  nlb_zone_id = module.nlb.nlb_zone_id
}



