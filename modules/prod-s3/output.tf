output "website_endpoint" {
  value = aws_s3_bucket.HCN_Prod_Bucket.website_endpoint
  description = "The URL of the static website hosted on S3"
}