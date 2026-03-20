terraform {
  backend "s3" {
    bucket       = "lovelu-s3-remotebackend"
    key          = "dev/vpc/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true

  }

}