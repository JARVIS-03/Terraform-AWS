
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "nlb_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = false
  }
}