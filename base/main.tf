terraform {
  cloud {
    organization = "alex-personal-terraform"

    workspaces {
      tags = ["aws-infrastructure"]
    }
  }

  required_version = "1.3.7"
}

locals {
  namespace = "${var.app_name}-${var.environment}"
}

module "log" {
  source = "../modules/cloudwatch"

  namespace                     = local.namespace
  secret_cloudwatch_log_key_arn = module.kms.secret_cloudwatch_log_key_arn
}

module "vpc" {
  source = "../modules/vpc"

  namespace = local.namespace
}

module "kms" {
  source = "../modules/kms"

  namespace = local.namespace
  region    = var.region

  secrets = {
    secret_key_base = var.secret_key_base
  }
}

module "security_group" {
  source = "../modules/security_group"

  namespace = local.namespace
  vpc_id    = module.vpc.vpc_id
  app_port  = var.app_port
}

module "s3" {
  source = "../modules/s3"

  namespace = local.namespace
}

module "alb" {
  source = "../modules/alb"

  vpc_id             = module.vpc.vpc_id
  namespace          = local.namespace
  app_port           = var.app_port
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = module.security_group.alb_security_group_ids
  health_check_path  = var.health_check_path
}
