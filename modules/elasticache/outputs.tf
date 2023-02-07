output "redis_primary_endpoint" {
  description = "Redis primary endpoint"
  value       = "redis://${aws_elasticache_replication_group.main.primary_endpoint_address}:${var.port}"
}
