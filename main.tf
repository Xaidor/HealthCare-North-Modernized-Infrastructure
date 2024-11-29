/*
Is this for backend setup? Can I remove it if its not needed? -Kaylen 

resource "aws_s3_bucket" "HealthCare_North" {
  bucket = "healthcare-north-pod4-project"
  tags = {
    Name        = "Bucket for Development Environment"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.HealthCare_North.id
  versioning_configuration {
    status = "Enabled"
  }
}
*/

# S3 bucket for development  
module "dev-s3-website" {
  source   = "./modules/dev-s3"
  s3bucket = var.s3bucket
}
