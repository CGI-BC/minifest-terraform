terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Add data sources here for existing resources (VPC, subnets, etc.)
# data "aws_vpc" "main" {
#   id = var.vpc_id
# }
