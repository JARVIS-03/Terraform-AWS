variable "aws_region" {
  description = "AWS Region to deploy resources in"
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
