variable "s3bucket" {
  default     = "healthcare-dev-s3-blackco-bucket"
  description = "Unique bucket name"
}

variable "pipeline_arn" {
  type        = string
  description = "filler for codepipeline arn"
}
