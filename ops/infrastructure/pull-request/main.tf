terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config  = {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/global.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-state-lock"
  }
}

locals {
  global_config = data.terraform_remote_state.global.outputs
  name          = "${random_pet.shop_name.id}-shop"
}

resource "random_pet" "shop_name" {
  keepers   = {
    id = var.id
  }
  separator = "-"
}