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

variable "instances" {
  type = number
  default = 1
  description = "Number of instances"
}

variable "database_url" {
  type        = string
  description = "Database URL"
}

variable "inbound_security_groups" {
  type        = list(string)
  default     = []
  description = "List of inbound connections security groups"
}

variable "assigned_security_groups" {
  type        = list(string)
  default     = []
  description = "List of assigned security groups"
}
