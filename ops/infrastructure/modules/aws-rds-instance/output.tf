output "host" {
  description = "Database host"

  value = aws_db_instance.main.address
}

output "connection_url" {
  description = "URL that allow connection to a database"
  sensitive = true
  value = "postgres://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.name}"
}
