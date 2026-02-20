include {
  path = find_in_parent_folders()
}

generate "prod_tfvars" {
  path              = "prod.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    # Prod-specific variables — fill in your values
    # vpc_id    = "vpc-xxxxxxxxxxxxxxxxx"
    # subnet_id = "subnet-xxxxxxxxxxxxxxxxx"
  EOF
}
