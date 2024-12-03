output "bucket_arn" {
  value = aws_s3_bucket.HCN_Dev_Bucket.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.HCN_Dev_Bucket.bucket_regional_domain_name
}

output "s3_bucket_bucket" {
  value  = aws_s3_bucket.HCN_Dev_Bucket.bucket
}