variable "name" {
  type        = string
  description = "Name of instance"
}

variable "vpc" {
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}

variable "instance_ids" {
  type        = list(string)
  default     = []
  description = "Instances to attach to the load balancer"
}

variable "autoscaling_group_ids" {
  type        = list(string)
  default     = []
  description = "Autoscaling Groups to attach to the load balancer"
}

variable "assigned_security_groups" {
  type        = list(string)
  default     = []
  description = "List of assigned security groups"
}

