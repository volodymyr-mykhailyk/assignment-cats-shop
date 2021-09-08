output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_certificate" {
  value = module.eks.cluster_ca_certificate
  sensitive = true
}

output "els_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "database_url" {
  value     = module.database.connection_url
  sensitive = true
}
