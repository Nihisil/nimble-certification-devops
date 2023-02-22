terraform {
  cloud {
    organization = "alex-personal-terraform"

    workspaces {
      name = "devops-ic-shared"
    }
  }

  required_version = "1.3.7"
}

module "ecr" {
  source = "../modules/ecr"

  namespace   = var.app_name
  image_limit = var.image_limit
}
