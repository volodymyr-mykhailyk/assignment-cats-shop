variable "name" {
  type        = string
  description = "Name of all infrastructure"
  default     = "cats-shop"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC Cidr"
  default     = "10.0.0.0/16"
}

