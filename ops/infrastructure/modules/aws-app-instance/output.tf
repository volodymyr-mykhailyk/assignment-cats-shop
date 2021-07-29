output "ids" {
  value = aws_instance.instance.*.id
}

output "public_ips" {
  description = "Public Instance Ip"

  value = aws_instance.instance.*.public_ip
}

output "public_endpoints" {
  description = "Public Instance Endpoints"

  value = aws_instance.instance.*.public_dns
}
