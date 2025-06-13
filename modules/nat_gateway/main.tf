resource "aws_eip" "nat" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  depends_on    = [aws_eip.nat]

  tags = {
    Name = "nat-gateway-${count.index}"
    EIP-Name   = "nat-eip-${count.index}"
  }
  
}
