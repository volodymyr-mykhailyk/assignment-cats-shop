output "vpc_id" {
  description = "VPC Id"

  value = aws_vpc.main.id
}

output "subnet_ids" {
  description = "VPC Id"

  value = aws_subnet.public.*.id
}

output "availability_zones" {
  description = "Availability Zones"

  value = aws_subnet.public.*.availability_zone
}
