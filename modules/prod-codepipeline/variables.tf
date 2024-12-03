variable "github_owner" {
    description = "The GitHub user or organization that owns the repository."
    type        = string
}

variable "github_repo" {
    description = "The GitHub repository to integrate."
    type        = string
}

variable "codestar_connection_arn" {
    description = "The ARN of the CodeStar connection."
    type        = string
}


variable "artifact_location" {
  type = string
  description = "Grabbing the prod-s3 bucket. Left empty to add later in the pareent module from the prod s3 child module"
}

variable "HCN_arn_role" {
  type        = string
  default     = "arn:aws:iam::060795916438:role/CodePipelineServiceRole"
}
