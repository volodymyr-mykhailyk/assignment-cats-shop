module "vpc" {
  source = "../modules/aws-vpc"

  name       = var.name
  cidr_block = var.vpc_cidr
}

