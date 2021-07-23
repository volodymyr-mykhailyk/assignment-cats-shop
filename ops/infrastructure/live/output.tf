output "vpc_id" {
  value = data.terraform_remote_state.global.outputs.vpc_id
}

output "public_ip" {
  value = module.instance.public_ip
}
