locals {
  db_url = "postgresql://${var.username}:${var.password}@${module.rds.cluster_endpoint}/${var.database_name}"
}

output "db_endpoint" {
  value = module.rds.cluster_endpoint
}

output "db_url" {
  value = local.db_url
}
