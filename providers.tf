terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "aryan-tf-state-597720"
    key            = "vpc/production/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}
