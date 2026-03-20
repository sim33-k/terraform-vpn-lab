terraform {
  backend "s3" {
    bucket       = "wireguard-lab-tfstate"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
