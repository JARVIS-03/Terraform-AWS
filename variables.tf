variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key from .csv"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key from .csv"
  type        = string
  sensitive   = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "db_instance_class" {
  description = "Database instance class"
  type = string
  
}


variable "db_name" {
  description = "Database name"
  type        = string
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

variable "ecr_image" {
  description = "Docker Image from ECR"
  type = string
  
}

variable "domain_name" {
  description = "domain to create (e.g., example.com)"
  type        = string
}

variable "record_name" {
  description = "subdomain to create (e.g., app.example.com)"
  type        = string
}

