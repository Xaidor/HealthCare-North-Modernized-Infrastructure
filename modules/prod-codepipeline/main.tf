 /* CodePipeline Draft as a source repo 
 THIS RESOURCE HAS NOT BEEN FULLY TESTED! CODE BUILD NEEDED
 */

resource "aws_codestarconnections_connection" "HCN_github" {
  name          = "HealthCareNorth-GitHub-connection"
  provider_type = "GitHub"

  tags = {
    Project = "HealthCareNorth"
    Environtment = "Prod"
  }
}
resource "aws_codepipeline" "HCN_codepipeline"{
    name = "HealthCare-prod-blackco-pipeline"
    role_arn = var.HCN_arn_role

    artifact_store { 
        type = "S3"
        location = var.artifact_location
    }
    stage {
        name = "Source"

        action {
            name             = "GitHubSource"
            category         = "Source"
            owner            = "AWS"
            provider         = "CodeStarSourceConnection"
            version          = "1"
            output_artifacts = ["source_output"]

            configuration = {
                ConnectionArn = var.codestar_connection_arn
                FullRepositoryId  = "${var.github_owner}/${var.github_repo}"
                BranchName = "dev"
            }
        }
    }
    stage {
        name = "Build"

        action{
            name = "HealthCare-North-Build"
            category = "Build"
            owner = "AWS"
            provider = "Codebuild"
            input_artifacts = ["source_output"]
            output_artifacts = ["build_output"]
            version = "1"

            configuration = {
                ProjectName = "HealthCare North Infrastructure"
            }
        }
    }
    # Add deploy stage here

}

