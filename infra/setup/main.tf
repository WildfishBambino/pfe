terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }

  backend "s3" {
    bucket         = "devsecopss3tfstate"
    key            = "tf-state-setup"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "Dynamodb-tf-state-lock"
  }
}

provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      Environment = terraform.workspace
      Project     = var.project
      contact     = var.contact
      ManageBy    = "Terraform/setup"
    }
  }
}
