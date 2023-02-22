output "secrets_variables" {
  description = "The formatted secrets for Task Definition"
  value       = local.secrets_variables
}

output "secret_arns" {
  description = "The secrets ARNs for Task Definition"
  value       = local.secret_arns
}

output "secret_cloudwatch_log_key_arn" {
  description = "The key to use for cloudwatch logs encryption"
  value       = local.secret_cloudwatch_log_key_arn
}
