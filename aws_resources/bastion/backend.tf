terraform {
  backend "s3" {
    bucket  = "limble-assessment-tf-state"
    key     = "aws_resources/bastion/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}