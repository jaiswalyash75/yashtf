terraform {
  backend "s3" {
    bucket = "21031-yash-tf"
    key    = "terraform/state"
    region = "us-east-1"
  }
}