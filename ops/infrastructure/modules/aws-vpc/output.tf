output "vpc_id" {
  description = "VPC Id"

  value = aws_vpc.main.id
}

output "subnet_ids" {
  description = "VPC Id"

  value = [for subnet in aws_subnet.public: subnet.id]
}

output "availability_zones" {
  description = "Availability Zones"

  value = [for subnet in aws_subnet.public: subnet.availability_zone]
}
