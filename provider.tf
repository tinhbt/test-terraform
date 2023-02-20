terraform {
  backend "s3" {
    bucket  = "tinhbt-code-artifact-test"
    key     = "terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "default"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}