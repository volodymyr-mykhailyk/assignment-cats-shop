variable "name" {
  type        = string
  description = "Name of instance"
}

variable "vpc" {
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
    cidr_block = string
  })
  description = "VPC information"
}
