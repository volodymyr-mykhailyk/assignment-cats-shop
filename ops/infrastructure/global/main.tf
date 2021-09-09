terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/global.tfstate"
    region = "eu-central-1"
  }
}

data "aws_availability_zones" "all" {
}

module "vpc" {
  source = "../modules/aws-vpc"

  name               = var.name
  cidr_block         = var.vpc_cidr
  availability_zones = reverse(data.aws_availability_zones.all.names)
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}