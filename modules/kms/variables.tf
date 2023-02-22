variable "namespace" {
  description = "The namespace for the KMS"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to keep in AWS Secrets Manager"
  type        = map(string)
  default     = {}
}

variable "deletion_window" {
  description = "Number of days before a key actually gets deleted once it's been scheduled for deletion. Valid value between 7 and 30 days"
  type        = number
  default     = 7
}

variable "region" {
  description = "AWS region"
  type        = string
}
