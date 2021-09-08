terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/live.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/global.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-state-lock"
  }
}

locals {
  global_config = data.terraform_remote_state.global.outputs
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

resource "aws_ecr_repository" "repo" {
  name = var.name
}

resource "aws_security_group" "cluster_access" {
  name_prefix = "${var.name}-eks-access-"
  vpc_id      = local.global_config.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.global_config.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.global_config.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "database" {
  source = "../modules/aws-rds-instance"
  name   = var.name
  vpc    = local.global_config
}

module "eks" {
  source = "../modules/aws-eks-cluster"
  name   = var.name
  vpc    = local.global_config

  instances_count       = 2
  instances_type        = "t2.micro"
  cluster_access_groups = [aws_security_group.cluster_access.id]
}