output "codestar_connection_arn" {
    value = aws_codestarconnections_connection.HCN_github.arn
}

output "codepipeline_name" {
    value = aws_codepipeline.HCN_codepipeline.name
}

output "pipeline_role_arn" {
  value       = var.HCN_arn_role
  description = "IAM Role ARN used by CodePipeline"
}
