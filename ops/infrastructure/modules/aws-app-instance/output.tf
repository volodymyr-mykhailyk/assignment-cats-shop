output "ids" {
  value = aws_instance.instance.*.id
}

output "public_ips" {
  description = "Public Instance Ip"

  value = aws_instance.instance.*.public_ip
}

output "public_dns" {
  value = aws_instance.instance.*.public_dns
}

output "connection_security_group_id" {
  value = var.app_configuration.connection_security_group_id
}
