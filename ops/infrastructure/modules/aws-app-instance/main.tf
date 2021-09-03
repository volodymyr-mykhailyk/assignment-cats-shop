resource "aws_instance" "instance" {
  count = var.instances

  launch_template {
    id      = var.app_configuration.id
    version = var.app_configuration.version
  }

  instance_type = "t2.micro"

  subnet_id = element(var.vpc.subnet_ids, count.index)

  tags = {
    Name = "${var.name}-${count.index}"
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}
