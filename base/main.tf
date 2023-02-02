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
