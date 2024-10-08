
provider "aws" {
  region     = "ap-south-1"
  access_key = "ACcess Key"
  secret_key = "secret Key"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33.0"
    }
  }
}