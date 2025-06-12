variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "allowed_sg_ids" {
  type = list(string)
}

variable "identifier" {
  default = "ecom-db"
}
variable "db_name" {}
variable "username" {}
variable "password" {
  sensitive = true
}

variable "port" {
  default = 5432
}
variable "allocated_storage" {
  default = 20
}
variable "instance_class" {
  default = "db.t3.micro"
}
variable "engine" {
  default = "postgres"
}
variable "engine_version" {
  default = "15"
}
