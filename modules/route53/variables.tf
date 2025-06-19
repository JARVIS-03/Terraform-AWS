
variable "domain_name" {
  description = "The domain name to create the hosted zone for"
  type        = string
}

variable "record_name" {
  description = "The subdomain (e.g., 'app.example.com')."
  type        = string
}

# variable "zone_id" {
#   description = "Route53 hosted zone ID"
#   type        = string
# }

variable "nlb_dns_name" {
  description = "The DNS name of the NLB to alias"
  type        = string
}

variable "nlb_zone_id" {
  description = "NLB Zone ID"
  type        = string
}