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
  }
}

data "terraform_remote_state" "live" {
  backend = "s3"
  config  = {
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
  live_config   = data.terraform_remote_state.live.outputs
  name          = "pr-${var.id}"
  db_name = "${random_pet.shop_name.id}-shop-db"
}

resource "random_pet" "shop_name" {
  keepers   = {
    id = var.id
  }
  separator = "-"
}

resource "random_password" "db_password" {
  length  = 12
  special = false
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.name
  }
}

resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name = "${local.db_name}-config"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  data = {
    POSTGRES_DB       = "app"
    POSTGRES_USER     = "app"
    POSTGRES_PASSWORD = random_password.db_password.result
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = local.db_name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.db_name
      }
    }
    template {
      metadata {
        labels = {
          app = local.db_name
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:10.4"
          port {
            container_port = 5432
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.postgres_config.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = local.db_name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
  spec {
    type = "ClusterIp"
    selector = {
      app = kubernetes_deployment.postgres.metadata[0].name
    }
    port {
      name        = "psql"
      port        = 5432
      protocol    = "TCP"
      target_port = 5432
    }
  }
}