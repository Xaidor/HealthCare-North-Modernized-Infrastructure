variable "s3bucket" {
  default     = "healthcare-dev-s3-blackco-bucket"
  description = "Unique bucket name"
}

variable "bucket_id" {
  type        = string
  default     = "HCN_Dev_Bucket"
  description = "description"
}
