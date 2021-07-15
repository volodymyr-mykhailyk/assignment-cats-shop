terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/global.tfstate"
    region = "eu-central-1"
  }
}

module "vpc" {
  source = "../modules/aws-vpc"

  name       = var.name
  cidr_block = var.vpc_cidr
}
