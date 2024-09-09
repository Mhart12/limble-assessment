provider "aws" {
  region = var.region
}

# needed to grab the ACM cert from us-east-1 because Cloudfront req.
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}