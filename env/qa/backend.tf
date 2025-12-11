terraform {
  backend "s3" {
    bucket         = "fdx-2938"
    key            = "env/qa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra-table"
    encrypt        = true
  }
}
