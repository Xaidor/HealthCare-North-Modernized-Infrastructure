variable "s3bucket" {
  default     = "healthcare-dev-s3-blackco-bucket"
  description = "Unique bucket name"
}

variable "north_america_restrictions" {
  default     = ["US", "MX", "CA"]
  description = "restrictions for North America. Mexico, United States, and Canada"
}

locals {
  cf_origin_id = "HCN-prod-blackco-CloudFront"
}