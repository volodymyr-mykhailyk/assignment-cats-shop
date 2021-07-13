data "aws_availability_zones" "all" {
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

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
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone = element(data.aws_availability_zones.all.names, count.index)

  tags = {
    Name = "${var.name}-public-1"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

# Day 2

resource "aws_key_pair" "server_key" {
  key_name_prefix = var.name
  public_key      = file("~/.ssh/id_rsa.pub")
}

module myip {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id
  name = "${var.name}-instance"

  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = ["${module.myip.address}/32"]
    protocol = "tcp"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.nano"

  key_name = aws_key_pair.server_key.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id = aws_subnet.public.1.id

  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-1"
  }
}