include {
  path = find_in_parent_folders()
}

generate "test_tfvars" {
  path              = "test.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    # Test-specific variables — fill in your values
    # vpc_id    = "vpc-xxxxxxxxxxxxxxxxx"
    # subnet_id = "subnet-xxxxxxxxxxxxxxxxx"
  EOF
}
