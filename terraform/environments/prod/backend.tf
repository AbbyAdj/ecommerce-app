# Backend

terraform {
  backend "s3" {
    bucket = "ecommerce-project-prod-backend"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-2"
  }
}

# Provider

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "E-Commerce Project"
      Management  = "Terraform Managed"
      Repo        = "https://github.com/AbbyAdj/ecommerce-app"
    }
  }
}


