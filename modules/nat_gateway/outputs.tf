output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
}

output "nat_eip_ids" {
  value = aws_eip.nat[*].id
}
