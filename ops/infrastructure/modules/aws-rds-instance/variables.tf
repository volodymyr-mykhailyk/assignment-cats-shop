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

variable "inbound_security_groups" {
  type        = list(string)
  description = "List of inbound security groups that allow connection to the db"
}

