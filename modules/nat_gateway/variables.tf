variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "project" {
  description = "Project name"
  type = string
  
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the NAT Gateway"
  type        = list(string)
}

variable "igw_id" {
  description = "Internet Gateway ID"
}

