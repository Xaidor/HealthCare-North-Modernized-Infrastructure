resource "aws_s3_bucket" "HCN_Prod_Bucket" {
  bucket = var.s3bucket

  tags = {
    Name        = "HealthCare North Static Website"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_acl_ownership" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_object" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id
  key    = "index.html"
  source = "./modules/prod-s3/index.html"
}

resource "aws_s3_object" "error_object" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id
  key    = "error.html"
  source = "./modules/prod-s3/error.html"
}

resource "aws_s3_bucket_policy" "hcn_public_policy" {
  bucket = aws_s3_bucket.HCN_Prod_Bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.HCN_Prod_Bucket.arn}/*"
      },
      {
        Sid       = "CodePipelineAccess"
        Effect    = "Allow"
        Principal = {
          AWS = var.pipeline_arn
        }
        Action    = [
          "s3:GtObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Reesource  = [
          aws_s3_bucket.HCN_Prod_Bucket.arn,
          "${aws_s3_bucket.HCN_Prod_Bucket.arn}/*"
        ]
      }
    ]
  })
}
