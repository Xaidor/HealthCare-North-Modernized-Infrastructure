resource "aws_codestarconnections_connection" "Dev_github" {
  name          = "Dev-HealthCare"
  provider_type = "GitHub"

  tags = {
    Project     = "HealthCareNorth"
    Environment = "Dev"
  }
}

resource "aws_codepipeline" "HCN_dev_pipeline" {
  name     = "HealthCare-dev-pipeline"
  role_arn = var.HCN_arn_role

  artifact_store { 
    type     = "S3"
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
        ConnectionArn    = aws_codestarconnections_connection.Dev_github.arn
        FullRepositoryId =  "${var.github_owner}/${var.github_repo}" 
        BranchName       = "dev"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Dev-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.DevBuild.name
      }
    }
  }

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

resource "aws_codebuild_project" "DevBuild" {
  name          = "HealthCare-Dev-Build"
  description   = "Build for development pipeline"
  service_role  = var.build_service_role_arn
  artifacts {
    type     = "S3"
    location = var.artifact_location
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0" 
    type         = "LINUX_CONTAINER"
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://github.com/${var.github_owner}/${var.github_repo}"
    buildspec       =  file("./modules/dev-codepipeline/buildspec.yml")
  }
}