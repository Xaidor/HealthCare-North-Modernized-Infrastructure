# CodePipeline Draft as a source repo
resource "aws_codepipeline" "HCN_codepipeline"{
    name = "HealthCare-prod-blackco-pipeline"
    role_arn = aws_iam_role.<grab role>.arn

    artifact_store { 
        type = "S3"
        location = aws_s3_bucket.<prod-bucket>.bucket
    }
    stage {
        name = "Source"

        action {
            name = "Source"
            category = "Source"
            owner = "ThirdParty"
            provider = "GitHub"
            version = "1"
            output_artifacts = ["SourceOutput"]

            configuration = {
                Owner = "Xaidor"
                Repo = "HealthCare-North-Modernized-Infrastructure"
                Branch = "main"
                OAuthToken = var.github_token

            }
        }
    }
}
resource "aws_iam_policy_attachment" "codepipeline_policy_attach" {
    name = "CodePipelinePermissions"
    roles = []
    policy_arn = "arn:aws:iam:aws:policy/<...>"
}
