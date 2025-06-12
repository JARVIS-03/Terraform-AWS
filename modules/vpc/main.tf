provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ecom-vpc"
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "ecom-igw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1
  availability_zone = var.az1
  # map_customer_owned_ip_on_launch = true
  tags = {
    Name = "ecom-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2
  availability_zone = var.az2
  # map_customer_owned_ip_on_launch = true
  tags = {
    Name = "ecom-public-subnet-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1
  availability_zone = var.az1
  # map_customer_owned_ip_on_launch = false
  tags = {
    Name = "ecom-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2
  availability_zone = var.az2
  # map_customer_owned_ip_on_launch = false
  tags = {
    Name = "ecom-private-subnet-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id         = aws_vpc.main.id
  tags = {
    Name = "ecom-public-route"
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  # vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_1.id
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name="ecom-natgw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {Name = "ecom-private-rt"}
}

resource "aws_route" "private_nat_route" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
