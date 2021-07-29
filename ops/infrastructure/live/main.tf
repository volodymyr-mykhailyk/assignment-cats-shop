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
}

module "instances" {
  source = "../modules/aws-app-instance"

  name      = var.name
  vpc    = local.global_config

  instances = 3
  database_url = module.database.connection_url

  inbound_security_groups = [module.balancer.connection_security_group_id]
  assigned_security_groups = [module.database.connection_security_group_id]
}

module "balancer" {
  source = "../modules/aws-load-balancer"

  name = var.name
  vpc = local.global_config

  instance_ids = module.instances.ids
}