output "vpc_id" {
  value = data.terraform_remote_state.global.outputs.vpc_id
}

output "public_ips" {
  value = module.instances.public_ips
}

output "public_endpoint" {
  value = module.balancer.public_endpoint
}

output "database_host" {
  value = module.database.host
}

output "database_url" {
  value = module.database.connection_url
  sensitive = true
}
