variable "cf_domain_name" { 
  type        = string
  description = "Regional domain name of the S3 bucket for CloudFront"
}

variable "s3_bucket_arn" {
  type        = string
}

variable "dev_origin_id" {
  type        = string
  default     = "HCN-dev-blackco2024-CloudFront"
}

