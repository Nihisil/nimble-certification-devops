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

module "vpc" {
  source = "../modules/vpc"

  namespace = local.namespace
}

module "kms" {
  source = "../modules/kms"

  namespace = local.namespace

  secrets = {
    secret_key_base = var.secret_key_base
  }
}
