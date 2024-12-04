output "codestar_connection_arn" {
    value = aws_codestarconnections_connection.HCN_github.arn
}

output "codepipeline_name" {
    value = aws_codepipeline.HCN_codepipeline.name
}

output "pipeline_role_arn" {
    value = aws_iam_role.HCN_codepipeline.arn
}
