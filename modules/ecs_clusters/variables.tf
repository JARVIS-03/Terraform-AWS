variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for ECS service"
  type        = list(string)
}

variable "db_host" {
  description = "Database host"
  type        = string
  
}

variable "db_port" {
  description = "Database port"
  type        = string
  default = "5432"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "alb_listener_arn" {
  description = "ALB Listener ARN to attach ECS services"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}


variable "services" {
  description = "Map of ECS services with container definition info"
  type = map(object({
    container_name    = string
    container_port    = number
    cpu               = number
    memory            = number
    desired_count     = number
    image             = string
    health_path       = string
  }))
}