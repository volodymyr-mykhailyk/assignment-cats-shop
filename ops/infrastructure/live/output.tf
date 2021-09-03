output "public_ip" {
  value = module.instances.public_ips[0]
}

output "public_endpoint" {
  value = module.instances.public_dns[0]
}

output "database_url" {
  value = module.database.connection_url
  sensitive = true
}

output "ssh_key_public" {
  value = tls_private_key.ssh_key.public_key_openssh
}

output "ssh_key_private" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
