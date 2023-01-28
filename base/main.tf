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

module "log" {
  source = "../modules/cloudwatch"

  namespace = var.app_name
}

module "security_group" {
  source = "../modules/security_group"

  namespace                   = local.namespace
  vpc_id                      = module.vpc.vpc_id
  app_port                    = var.app_port
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
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

module "ecs" {
  source = "../modules/ecs"

  subnets                            = module.vpc.private_subnet_ids
  namespace                          = local.namespace
  region                             = var.region
  app_host                           = module.alb.alb_dns_name
  app_port                           = var.app_port
  ecr_repo_name                      = var.app_name
  ecr_tag                            = var.ecr_tag
  security_groups                    = module.security_group.ecs_security_group_ids
  alb_target_group_arn               = module.alb.alb_target_group_arn
  aws_cloudwatch_log_group_name      = module.log.aws_cloudwatch_log_group_name
  deployment_maximum_percent         = var.ecs.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs.deployment_minimum_healthy_percent
  web_container_cpu                  = var.ecs.web_container_cpu
  web_container_memory               = var.ecs.web_container_memory

  secrets_variables = module.kms.secrets_variables
  secret_arns       = module.kms.secret_arns
}
