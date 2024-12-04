resource "aws_s3_bucket" "HealthCare_North" {
  bucket = "healthcare-north-pod4-project"
  tags = {
    Name        = "Bucket for Development Environment"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.HealthCare_North.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket for development  
module "dev-s3-website" {
  source   = "./modules/dev-s3"
  s3bucket = var.s3bucket

  pipeline_arn = module.CI-CD-github-pipeline.pipeline_role_arn
}

# S3 bucket for Production
module "prod-s3-website" {
  source       = "./modules/prod-s3"
  s3bucket     = var.s3bucketprod

  pipeline_arn = module.CI-CD-github-pipeline.pipeline_role_arn
}

# CloudFront distribution
module "CF-static-website" {
  source         = "./modules/prod-cloudfront"

  s3_bucket_arn  = module.prod-s3-website.bucket_arn
  cf_domain_name = module.prod-s3-website.bucket_regional_domain_name
}

# CodePipeline 
module "CI-CD-github-pipeline" {
  source                  = "./modules/prod-codepipeline"

  artifact_location       = module.prod-s3-website.s3_bucket_bucket
  github_owner            = var.github_owner
  github_repo             = var.github_repo
}
