variable "cf_domain_name" { 
  type        = string
  description = "Regional domain name of the S3 bucket for CloudFront"
}

variable "s3_bucket_arn" {
  type        = string
}


locals {
  cf_origin_id = "HCN-prod-blackco-CloudFront"
}
