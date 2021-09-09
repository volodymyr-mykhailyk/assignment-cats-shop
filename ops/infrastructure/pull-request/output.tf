output "name" {
  value = local.name
}

output "namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}

output "ecr_repository_url" {
  value = local.live_config["ecr_repository_url"]
}

output "eks_cluster_name" {
  value = local.live_config["eks_cluster_name"]
}

output "database_url" {
  value = "postgres://app:${random_password.db_password.result}@${kubernetes_service.postgres.spec[0].cluster_ip}:5432/app"
  sensitive = true
}