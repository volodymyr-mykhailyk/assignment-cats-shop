module "vpc" {
  source = "./modules/aws-vpc"


  name       = var.name
  cidr_block = var.vpc_cidr
}

module "instance" {
  source = "./modules/aws-app-instance"


  name      = var.name
  vpc_id    = module.vpc.vpc_id
  subnet_id = element(module.vpc.subnet_ids, 0)
}
