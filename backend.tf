terraform {
  backend "s3" {
    bucket = "lpx-python-db-backups"
    key    = "pmx/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}

