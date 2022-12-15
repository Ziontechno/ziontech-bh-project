
 
 terraform {
  required_providers {
    aws = {
      
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


data "aws_availability_zones" "available" {}


 