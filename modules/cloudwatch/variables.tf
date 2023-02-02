variable "namespace" {
  description = "The namespace for the CloudWatch"
  type        = string
}

variable "log_retention_in_days" {
  description = "How long (days) to retain the log data"
  default     = 14
}

variable "secret_cloudwatch_log_key_arn" {
  description = "The key to use for logs encryption"
  type        = string
}
