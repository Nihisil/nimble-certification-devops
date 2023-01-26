variable "app_name" {
  description = "Application name"
  type        = string
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

variable "secret_key_base" {
  description = "The Secret key base for the application"
  type        = string
}

variable "app_port" {
  description = "Application running port"
  type        = number
}

variable "health_check_path" {
  description = "The health check path of the Application"
  type        = string
}

variable "ecr_tag" {
  description = "ECR tag to deploy"
  type        = string
}

variable "ecs" {
  description = "ECS input variables"
  type = object({
    web_container_cpu                  = number
    web_container_memory               = number
    deployment_maximum_percent         = number
    deployment_minimum_healthy_percent = number
  })
}
