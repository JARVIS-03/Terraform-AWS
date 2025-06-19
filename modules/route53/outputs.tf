
output "route53_record_fqdn" {
  description = "Fully qualified domain name created"
  value = aws_route53_record.nlb_alias.fqdn
}

output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "route53_record_name" {
  value = aws_route53_record.nlb_alias.name
}
