resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "main" {
  identifier_prefix = "${var.name}-"

  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  name     = replace(var.name, "-", "_")
  username = "root"
  password = random_password.password.result

  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.networks.name
  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_db_subnet_group" "networks" {
  name_prefix = "${var.name}-"
  subnet_ids  = var.vpc.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "main" {
  vpc_id      = var.vpc.vpc_id
  name_prefix = "${var.name}-db-"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.connector.id]
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
  vpc_id = var.vpc.vpc_id

  name_prefix = "${var.name}-db-connector-"
}