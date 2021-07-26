resource "aws_db_instance" "main" {
  identifier_prefix = "${var.name}-"

  engine = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 5

  name = replace(var.name, "-", "_")
  username = "root"
  password = "some_long_password"

  publicly_accessible = false

  db_subnet_group_name = aws_db_subnet_group.networks.name
}

resource "aws_db_subnet_group" "networks" {
  name_prefix = "${var.name}-"
  subnet_ids = var.vpc.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}