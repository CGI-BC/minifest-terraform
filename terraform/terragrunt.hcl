terraform {
  source = "../..//services"
}

locals {
  project_name = "minifest"
  aws_region   = "ca-central-1"
  environment  = reverse(split("/", get_terragrunt_dir()))[0]
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-${local.project_name}-${local.environment}"
    key            = "${local.project_name}/${local.environment}/terraform.tfstate"
    dynamodb_table = "terraform-remote-state-lock-${local.project_name}"
    region         = "${local.aws_region}"
    encrypt        = true
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "${local.project_name}"
      Environment = "${local.environment}"
      ManagedBy   = "terragrunt"
    }
  }
}
EOF
}

generate "tfvars" {
  path              = "terragrunt.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    project_name = "${local.project_name}"
    aws_region   = "${local.aws_region}"
    target_env   = "${local.environment}"
  EOF
}
