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
  }
}

locals {
  global_config = data.terraform_remote_state.global.outputs
}

module "database" {
  source = "../modules/aws-rds-instance"
  name = var.name
  vpc = local.global_config
  inbound_security_groups = []
}

module "instance" {
  source = "../modules/aws-app-instance"

  name      = var.name
  vpc_id    = local.global_config.vpc_id
  subnet_id = element(local.global_config.subnet_ids, 0)
}
