output "codestar_connection_arn" {
    value = aws_codestarconnections_connection.HCN_github.arn
}

output "codepipeline_name" {
    value = aws_codepipeline.HCN_codepipeline.name
}
