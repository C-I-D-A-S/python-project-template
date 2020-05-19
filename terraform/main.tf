terraform {
  backend "s3" {
    encrypt = true
    bucket  = "example-dev-terraform-cicd"
    region  = "us-east-2"
    key     = "terraform.example-dev-cicd.public-example-api.tfstate"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}
resource "aws_ecr_repository" "example-api_ecr-repo" {
  name = "example/public-example-api"
}
