locals {
  availability_zones = sort(var.availability_zones)
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(local.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, index(local.availability_zones, each.key) + 1)
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}
