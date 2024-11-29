terraform {
  backend "s3" {
    bucket         = "healthcare-north-pod4-project"
    key            = "terraform/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock" # DynamoDB table for state locking

  }
}

