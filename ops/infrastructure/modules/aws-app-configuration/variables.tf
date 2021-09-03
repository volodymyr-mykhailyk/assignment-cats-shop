variable "name" {
  type        = string
  description = "Name of instance"
}

variable "vpc" {
  type        = object({
    vpc_id     = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}

variable "database_url" {
  type        = string
  description = "Database URL"
}

variable "ssh_key" {
  type = object({
    public_key_pem: string
    public_key_openssh: string
  })
  description = "SSH Key used to connect to the instance"
}

variable "assigned_security_groups" {
  type        = list(string)
  default     = []
  description = "List of assigned security groups"
}
