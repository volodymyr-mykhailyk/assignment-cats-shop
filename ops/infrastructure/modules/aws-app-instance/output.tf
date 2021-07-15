output "public_ip" {
  description = "Public Instance Ip"

  value = aws_instance.instance.public_ip
}
