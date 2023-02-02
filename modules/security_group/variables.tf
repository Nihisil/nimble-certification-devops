variable "namespace" {
  description = "The namespace for the security groups, used as the prefix for the VPC security group names, e.g. acme-web-staging"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "app_port" {
  description = "Application running port"
  type        = number
}
