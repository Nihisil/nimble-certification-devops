variable "app_name" {
  description = "Application name"
  default     = "devops-ic"
}

variable "environment" {
  description = "The application environment, used to tag the resources, e.g. `acme-web-staging`"
  type        = string
}

variable "owner" {
  description = "The owner of the infrastructure, used to tag the resources, e.g. `acme-web`"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Access Key Secret"
  type        = string
}

variable "image_limit" {
  description = "Sets max amount of the latest develop images to be kept"
  default     = 5
}
