variable "domain_name" {
  description = "The root domain name (e.g., example.com)"
  type        = string
}

variable "nlb_dns_name" {
  description = "The DNS name of the NLB to alias"
  type        = string
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}