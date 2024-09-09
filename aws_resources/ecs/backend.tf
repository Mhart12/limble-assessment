terraform {
  backend "s3" {
    bucket  = "limble-assessment-tf-state"
    key     = "aws_resources/ecs/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}