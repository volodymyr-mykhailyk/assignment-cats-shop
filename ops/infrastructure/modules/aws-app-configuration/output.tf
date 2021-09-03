output "id" {
  value = aws_launch_template.app.id
}

output "arn" {
  value = aws_launch_template.app.arn
}

output "version" {
  value = aws_launch_template.app.latest_version
}

output "connection_security_group_id" {
  value = aws_security_group.connector.id
}
