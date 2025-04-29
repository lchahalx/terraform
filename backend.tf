terraform {
  backend "s3" {
    bucket = "l<s3_name>"
    key    = "pmx/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}

