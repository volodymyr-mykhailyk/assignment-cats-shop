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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

module "database" {
  source = "../modules/aws-rds-instance"
  name   = var.name
  vpc    = local.global_config
}

module "app_config" {
  source = "../modules/aws-app-configuration"

  name    = var.name
  vpc     = local.global_config
  ssh_key = tls_private_key.ssh_key

  database_url = module.database.connection_url

  assigned_security_groups = [module.database.connection_security_group_id]
}

module "instances" {
  source = "../modules/aws-app-instance"

  name              = var.name
  vpc               = local.global_config
  app_configuration = module.app_config

  instances = 1
}
