variable "s3bucket" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "healthcare-north-pod4-project-prod-1"
}

variable "pipeline_arn" {
  type        = string
  description = "filler for codepipeline arn"
}
