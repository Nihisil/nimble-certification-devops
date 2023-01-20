terraform {
  cloud {
    organization = "alex-personal-terraform"

    workspaces {
      tags = ["aws-infrastructure"]
    }
  }
}

locals {
  namespace = "${var.app_name}-${var.environment}"
}

module "vpc" {
  source = "../modules/vpc"

  namespace = local.namespace
}

module "security_group" {
  source = "../modules/security_group"

  namespace = local.namespace
  vpc_id    = module.vpc.vpc_id
}

module "kms" {
  source = "../modules/kms"

  namespace = local.namespace

  secrets = {
    secret_key_base = var.secret_key_base
  }
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
