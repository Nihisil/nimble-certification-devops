resource "aws_cloudwatch_log_group" "main" {
  name              = "awslogs-${var.namespace}-log-group"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.secret_cloudwatch_log_key_arn
}
