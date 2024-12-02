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

variable "github_owner" {
    type        = string
    default     = "Xaidor" 
    description = "The GitHub user that owns the repository."
}

variable "github_repo" {
    type        = string
    default     = "HealthCare-North-Modernized-Infrastructure" 
    description = "The GitHub repository to integrate."
}

variable "codestar_connection_arn" {
    type        = string
    default     = "arn:aws:codestar-connections:region:account-id:connection/connection-id"
    description = "The ARN of the CodeStar connection."
}
