output "vpc_id" {
  value = data.terraform_remote_state.global.outputs.vpc_id
}

output "public_ip" {
  value = module.instance.public_ip
}

output "database_host" {
  value = module.database.host
}

output "database_url" {
  value = module.database.connection_url
  sensitive = true
}
