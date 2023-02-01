terraform {
  cloud {
    organization = "alex-personal-terraform"

    workspaces {
      tags = ["aws-infrastructure"]
    }
  }
}
