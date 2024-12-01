variable "github_token" {
  type        = string
  sensitive = true
  description = "GitHub OAuth token"
}

variable "artifact_location" {
  type = string
  description = "Grabbing the prod-s3 bucket. Left empty to add later in the pareent module from the prod s3 child module"
}