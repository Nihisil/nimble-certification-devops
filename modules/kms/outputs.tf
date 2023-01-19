output "secrets_variables" {
  description = "The formatted secrets for Task Definition"
  value       = local.secrets_variables
}

output "secret_arns" {
  description = "The secrets ARNs for Task Definition"
  value       = local.secret_arns
}
