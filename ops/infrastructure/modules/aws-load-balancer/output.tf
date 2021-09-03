output "public_endpoint" {
  description = "Public Endpoint for Balancer"

  value = aws_lb.balancer.dns_name
}

output "connection_security_group_id" {
  value = aws_security_group.main.id
}
