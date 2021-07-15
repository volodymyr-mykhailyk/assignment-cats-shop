module "vpc" {
  source = "./modules/aws-vpc"


  name       = var.name
  cidr_block = var.vpc_cidr
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
  vpc_id      = module.vpc.vpc_id
  name_prefix = "${var.name}-instance"
  description = "${var.name} instance"

  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${module.myip.address}/32"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
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

data "template_file" "user_data" {
  template = file("${path.module}/templates/app_user_data.sh.tpl")
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.nano"

  key_name               = aws_key_pair.server_key.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = element(module.vpc.subnet_ids, 1)

  user_data = data.template_file.user_data.rendered

  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-1"
  }
}