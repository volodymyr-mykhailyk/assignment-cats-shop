terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/live.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config  = {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/global.tfstate"
    region = "eu-central-1"
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

module "database" {
  source = "../modules/aws-rds-instance"
  name   = var.name
  vpc    = local.global_config
}

module "eks" {
  source = "../modules/aws-eks-cluster"
  name   = var.name
  vpc    = local.global_config

  instances_count = 2
  instances_type  = "t2.micro"
}