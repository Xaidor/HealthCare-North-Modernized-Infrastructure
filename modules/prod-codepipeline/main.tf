 /* CodePipeline 
Terraform plan = successful
Terraform validate = successful
Terraform apply = succesful
 */

resource "aws_codestarconnections_connection" "HCN_github" {
  name          = "HealthCareNorth"
  provider_type = "GitHub"

  tags = {
    Project     = "HealthCareNorth"
    Environment = "Prod"
  }
}

resource "aws_codepipeline" "HCN_codepipeline" {
  name     = "HealthCare-prod-pipeline"
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
        ConnectionArn    = aws_codestarconnections_connection.HCN_github.arn
        FullRepositoryId =  "${var.github_owner}/${var.github_repo}" 
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "HealthCare-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.HealthCareBuild.name
      }
    }
  }

  stage {
    name = "Deploy_to_prod_bucket"

    action {
      name            = "Deploy_to_bucket"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = "healthcare-north-pod4-project-prod-1"
        Extract    = "true"
      }
    }
  }
}

resource "aws_codebuild_project" "HealthCareBuild" {
  name          = "HealthCare-prod-build"
  description   = "Build for HealthCare-prod-pipeline"
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
    buildspec       =  file("./modules/prod-codepipeline/buildspec.yml")
  }
}

/* Not completed APPROVALS

resource "aws_codedeploy_deployment_config" "Prod_Approvals" {
  deployment_config_name = "test-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}
*/