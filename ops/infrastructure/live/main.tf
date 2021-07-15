terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/live.tfstate"
    region = "eu-central-1"
  }
}

//module "instance" {
//  source = "../modules/aws-app-instance"
//
//
//  name      = var.name
//  vpc_id    = module.vpc.vpc_id
//  subnet_id = element(module.vpc.subnet_ids, 0)
//}
