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

variable "app_configuration" {
  type        = object({
    id                           = string
    version                      = string
    connection_security_group_id = string
  })
  description = "Application config"
}
