include {
  path = find_in_parent_folders()
}

generate "dev_tfvars" {
  path              = "dev.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    # Dev-specific variables — fill in your values
    # vpc_id    = "vpc-xxxxxxxxxxxxxxxxx"
    # subnet_id = "subnet-xxxxxxxxxxxxxxxxx"
  EOF
}
