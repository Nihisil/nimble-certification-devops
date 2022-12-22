terraform {
  cloud {
    organization = "alex-personal-terraform"

    workspaces {
      tags = ["aws-infrastructure"]
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
    }
  }
}
