resource "aws_eip" "nat" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip-${count.index}"
  }


}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  depends_on    = [var.igw_id]

  tags = {
    Name     = "${var.project}-nat-gateway-${count.index}"
    EIP_Name = "${var.project}-nat-eip-${count.index}"
  }
  
}

