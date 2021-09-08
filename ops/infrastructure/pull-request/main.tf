terraform {
  backend "s3" {
    bucket = "terraform-state-517804334742"
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

data "terraform_remote_state" "live" {
  backend = "s3"
  config = {
    bucket = "terraform-state-517804334742"
    key    = "assignment-cats-shop/live.tfstate"
    region = "eu-central-1"
  }
}

provider "kubernetes" {
  host                   = local.live_config["els_cluster_endpoint"]
  cluster_ca_certificate = base64decode(local.live_config["eks_cluster_certificate"])
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.live_config["eks_cluster_name"]]
    command     = "aws"
  }
}

locals {
  global_config = data.terraform_remote_state.global.outputs
  live_config = data.terraform_remote_state.live.outputs
  name          = "pr-${var.id}"
}

resource "random_pet" "shop_name" {
  keepers = {
    id = var.id
  }
  separator = "-"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.name
  }
}