variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_port" {
  description = "Port the target group forwards to"
  type        = number
}

variable "listener_port" {
  description = "Port ALB listens on"
  type        = number
}
