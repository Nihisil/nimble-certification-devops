resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.namespace}-subnet-group"
  subnet_ids = var.subnet_ids
}

# tfsec:ignore:aws-elasticache-enable-in-transit-encryption tfsec:ignore:aws-elasticache-enable-at-rest-encryption
resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.namespace}-rep-group"
  description          = "${var.namespace} rep-group"

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = var.security_group_ids

  engine         = var.engine
  node_type      = var.node_type
  port           = var.port
  engine_version = var.engine_version

  parameter_group_name       = var.parameter_group_name
  automatic_failover_enabled = var.automatic_failover_enabled
  num_cache_clusters         = var.number_cache_clusters
  at_rest_encryption_enabled = false
}
