output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

output "cidr_block" {
  value = module.vpc.cidr_block
}
