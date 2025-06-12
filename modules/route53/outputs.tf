output "route53_record_fqdn" {
  value = aws_route53_record.nlb_alias.fqdn
}
