resource "aws_key_pair" "server_key" {
  key_name_prefix = var.name
  public_key      = var.ssh_key.public_key_openssh
}

resource "aws_security_group" "instance" {
  vpc_id      = var.vpc.vpc_id
  name_prefix = "${var.name}-app-"
  description = "${var.name} app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
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

resource "aws_security_group" "connector" {
  vpc_id      = var.vpc.vpc_id
  name_prefix = "${var.name}-app-connector-"
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

  vars = {
    database_url = var.database_url
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.server_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = concat([aws_security_group.instance.id], var.assigned_security_groups)
  }

  user_data = base64encode(data.template_file.user_data.rendered)
}
