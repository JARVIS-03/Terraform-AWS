variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}


variable "db_password" {
  description = "Password for RDS master user"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Your root domain (e.g., example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for your domain"
  type        = string
}
