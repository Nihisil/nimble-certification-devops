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
