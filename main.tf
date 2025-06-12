provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  project = var.project
  cidr_block = var.vpc_cidr
  azs = var.azs
}

module "nat_gateway" {
  source = "./modules/nat_gateway"
  project = var.project
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

module "nlb" {
  source = "./modules/nlb"
  project = var.project
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  project = var.project
  subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"

  project           = var.project
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  alb_listener_arn  = module.alb.listener_arn

  # services = {
  #   product = {
  #     container_name = "product-service"
  #     container_port = 8081
  #     cpu            = 256
  #     memory         = 512
  #     desired_count  = 2
  #     image          = "docker-repo"
  #     health_path    = "/actuator/health"
  #   }

  #   order = {
  #     container_name = "order-service"
  #     container_port = 8082
  #     cpu            = 256
  #     memory         = 512
  #     desired_count  = 2
  #     image          = "docker-repo"
  #     health_path    = "/actuator/health"
  #   }

  #   payment = {
  #     container_name = "payment-service"
  #     container_port = 8083
  #     cpu            = 256
  #     memory         = 512
  #     desired_count  = 2
  #     image          = "docker-repo"
  #     health_path    = "/actuator/health"
  #   }

  #   notification = {
  #     container_name = "notification-service"
  #     container_port = 8084
  #     cpu            = 256
  #     memory         = 512
  #     desired_count  = 2
  #     image          = "docker-repo"
  #     health_path    = "/actuator/health"
  #   }
  # }
}

module "rds" {
  source = "./modules/rds"

  project         = var.project
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  db_name         = "ecom-db"
  db_username     = "admin"
  db_password     = var.db_password
  db_instance_class = "db.t3.micro"
}

module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name
  nlb_dns_name = module.nlb.nlb_dns_name
  zone_id = var.hosted_zone_id
}
