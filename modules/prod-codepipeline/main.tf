 /* CodePipeline 
 THIS RESOURCE HAS NOT BEEN FULLY TESTED! CODE DEPLOY NEEDED
 */

resource "aws_codestarconnections_connection" "HCN_github" {
  name          = "HealthCareNorth-GitHub-connection"
  provider_type = "GitHub"

  tags = {
    Project = "HealthCareNorth"
    Environtment = "Prod"
  }
}
resource "aws_codepipeline" "HCN_codepipeline" {
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
    stage {
    name = "Deploy_to_dev_bucket"
    action {
      name            = "Deploy_to_bucket"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = "healthcare-dev-s3-blackco-bucket"
        Extract    = "true"
      }
    }
  }
}

