
output "route53_record_fqdn" {
  description = "Fully qualified domain name created"
  value = aws_route53_record.nlb_alias.fqdn
}
