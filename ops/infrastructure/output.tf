output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

output "public_ip" {
  value = module.instance.public_ip
}