resource "aws_autoscaling_group" "main" {
  name_prefix = "${var.name}-"

  min_size = 1
  max_size = 3

  launch_configuration = aws_launch_configuration.app.id
  health_check_type = "ELB"
  health_check_grace_period = "120"

  vpc_zone_identifier = var.vpc.subnet_ids
}

module myip {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

resource "aws_key_pair" "server_key" {
  key_name_prefix = var.name
  public_key      = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "instance" {
  vpc_id      = var.vpc.vpc_id
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
    security_groups = var.inbound_security_groups
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

  vars = {
    database_url = var.database_url
  }
}

resource "aws_launch_configuration" "app" {
  name_prefix = "${var.name}-"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name               = aws_key_pair.server_key.key_name
  security_groups = concat([aws_security_group.instance.id], var.assigned_security_groups)

  user_data = data.template_file.user_data.rendered

  associate_public_ip_address = true
}
