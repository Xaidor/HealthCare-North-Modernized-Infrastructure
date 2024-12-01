 /* CodePipeline Draft as a source repo 
 THIS RESOURCE HAS NOT BEEN TESTED! 
 Terraform plan and apply still need to be initiated. 

 Conserns and whats still needed:
    arn and using the correct syntax, resource, and attributes. 
    github_token still need to be created using the CLI.

 What has been done:
    Structure of the child module 90% commpleted. 
    Parent Mondule has been updated to refrence this codepipeline child module.
    Filler variable made for artifact location
    Variable created for github_token with sensitive setting to hide token
 */

resource "aws_codepipeline" "HCN_codepipeline"{
    name = "HealthCare-prod-blackco-pipeline"
    role_arn = "arn:aws:iam::060795916438:role/CodePipelineServiceRole"

    artifact_store { 
        type = "S3"
        location = var.artifact_location
    }
    stage {
        name = "Source"

        action {
            name             = "Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["SourceOutput"]

            configuration = {
                Owner  = "Xaidor"
                Repo   = "HealthCare-North-Modernized-Infrastructure"
                Branch = "dev"
                OAuthToken = var.github_token

            }
        }
    }
}
resource "aws_iam_policy_attachment" "codepipeline_policy_attach" {
    name         = "CodePipelinePermissions"
    roles        = ["arn:aws:iam::060795916438:role/CodePipelineServiceRole"]
    policy_arn   = "arn:aws:iam:aws:policy/<...>"
}
