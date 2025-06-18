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

variable "alb_listener_arn" {
  description = "ALB Listener ARN to attach ECS services"
  type        = string
}

# variable "db_username" {
#   description = "Username for the RDS instance"
#   type        = string
# }
#
#
# variable "db_password" {
#   description = "Password for RDS master user"
#   type        = string
#   sensitive   = true
# }
#
variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
  type        = string
}

variable "ecr_image" {
  description = "Docker Image from ECR"
  type = string

}

variable "alb_sg_id" {
  type        = string
}

variable "alb_target_arn" {
  type        = string
}

variable "alb_listener" {
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