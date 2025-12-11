terraform {
  backend "s3" {
    bucket         = "fdx-2938"
    key            = "env/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra-table"
    encrypt        = true
  }
}
