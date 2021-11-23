terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.66"
    }
  }
  
  backend "s3" {
    bucket         = "giffon-terraform"
    dynamodb_table = "giffon-terraform"
    key            = "giffon-terraform.tfstate"
  }
}

provider "aws" {}
data "aws_region" "current" {}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
