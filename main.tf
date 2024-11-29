/*resource "aws_s3_bucket" "HealthCare_North" {
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

