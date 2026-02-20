variable "target_env" {
  description = "Deployment environment (dev / test / prod)"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ca-central-1"
}

# Add your service-specific variables below
# variable "vpc_id" {
#   description = "VPC to deploy into"
#   type        = string
# }
