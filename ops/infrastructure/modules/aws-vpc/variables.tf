variable "name" {
  type        = string
  description = "Name of vpc"
}

variable "cidr_block" {
  type        = string
  description = "VPC Cidr"
}

variable "subnets_count" {
  type        = number
  default     = 2
  description = "Number of subnets to create"
}

