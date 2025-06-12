module "vpc" {
  source = "./vpc"

  vpc_cidr         = var.vpc_cidr
  public_subnet_1  = var.public_subnet_1
  public_subnet_2  = var.public_subnet_2
  private_subnet_1 = var.private_subnet_1
  private_subnet_2 = var.private_subnet_2
  az1              = var.az1
  az2              = var.az2
}

module "alb" {
  source = "./alb"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
}

module "rds" {
  source = "./rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
  allowed_sg_ids     = [module.alb.alb_sg_id]

  db_name   = "ecomdb"
  username  = "admin"
  password  = "yourStrongPassword123"
}




