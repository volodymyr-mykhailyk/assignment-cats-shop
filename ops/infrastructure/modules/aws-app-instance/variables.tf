variable "name" {
  type        = string
  description = "Name of instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to deploy"
}

variable "database_url" {
  type        = string
  description = "Database URL"
}

variable "assigned_security_groups" {
  type        = list(string)
  default     = []
  description = "List of assigned security groups"
}