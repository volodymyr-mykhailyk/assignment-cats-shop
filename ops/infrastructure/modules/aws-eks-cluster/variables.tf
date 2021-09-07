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

variable "instances_count" {
  type        = number
  default     = 2
  description = "Number of instances"
}

variable "instances_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of instances"
}

variable "cluster_access_groups" {
  type = list(string)
  default = []
  description = "EKS cluster security groups"
}
