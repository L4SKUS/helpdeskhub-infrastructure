terraform {
  backend "s3" {
    bucket         = "helpdeskhub-tfstate-bucket"
    key            = "helpdeskhub/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.37.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
