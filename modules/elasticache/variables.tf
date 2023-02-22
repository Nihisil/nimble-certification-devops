variable "namespace" {
  description = "The namespace for the ECR"
  type        = string
}

variable "engine" {
  description = "Cluster engine"
  default     = "redis"
}

variable "engine_version" {
  description = "Engine version"
  default     = "6.x"
}

variable "parameter_group_name" {
  description = "Parameter group for the cache cluster"
  default     = "default.redis6.x"
}

variable "node_type" {
  description = "Node type"
  default     = "cache.t3.small"
}

variable "port" {
  description = "Cache node port"
  type        = number
}

variable "automatic_failover_enabled" {
  description = "Whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails"
  default     = false
}

variable "number_cache_clusters" {
  description = "Number of cache clusters"
  default     = 1
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(any)
}

variable "security_group_ids" {
  description = "One or more VPC security groups associated with the cache cluster"
  type        = list(any)
}
