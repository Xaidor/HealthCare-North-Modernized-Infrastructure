resource "aws_s3_bucket" "HCN_Dev_Bucket" {
    bucket = var.s3bucket

/*Option 1 to enable static web hosting
    website {  
        index_document = "index.html"
        error_document = "error.html"
    }
*/
    tags = {
        Name         = "HealthCare North Static Website"
        Environment  = "Dev"
    }
}

resource "aws_s3_bucket_ownership_controls" "s3_acl_ownership" {
  bucket = aws_s3_bucket.HCN_Dev_Bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

#Option 2 for static web hosting. A more advance option
resource "aws_s3_bucket_website_configuration" "static_website_config" {
    bucket = aws_s3_bucket.HCN_Dev_Bucket.id  

    index_document {
        suffix = "index.html"
    }
    
    error_document {
        key = "error.html"
    }

}

# Adds needed objects to the bucket
resource "aws_s3_object" "index_object" {
  bucket = aws_s3_bucket.HCN_Dev_Bucket.id
  key    = "index.html"
  source = "./modules/dev-s3/index.html"
}

resource  "aws_s3_object" "error_opject" {
    bucket = aws_s3_bucket.HCN_Dev_Bucket.id
    key    = "error.html"
    source = "./modules/dev-s3/error.html"
}

resource "aws_s3_bucket_policy" "hcn_public_policy" {
  bucket = aws_s3_bucket.HCN_Dev_Bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.HCN_Dev_Bucket.arn}/*"
      },
      {
        Sid       = "CodePipelineAccess"
        Effect    = "Allow"
        Principal = {
          AWS = var.pipeline_arn
        }
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource  = [
          aws_s3_bucket.HCN_Dev_Bucket.arn,
          "${aws_s3_bucket.HCN_Dev_Bucket.arn}/*"
        ]
      }
    ]
  })
}