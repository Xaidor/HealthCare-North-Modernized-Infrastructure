# Rough draft module of CloudFront Distribution

resource "aws_cloudfront_distribution" "HealthCare_CF_Distribution" {
    origin {
        domain_name = aws_s3_bucket.<prod-bucket>.bucket_reginal_domain_name #Add s3 prod bucket
        origin_acces_control = aws_cloudfront_origin_acces_control.default.id
        origin_id = local.s3_origin_id
    }
    enabled = true  #enables or disables distribution
    is_ipv4_enabled = true
    comment = "HealthCare North CloudFront Disribution"
    default_root_object = "index.html"

    default_cache_behavior {
        target_origin_id = "<s3-prod-bucket>" #add s3 bucket
        viewer_protocol_policy = "redirect-to-https" 

        allow_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"] #common for static content

        forward_values {
            query_string = false 

            cookies {
                forward = "none" 
            }
        }
        min_ttl = 0 #Minimum time an object stays in the CloudFront cache
        default_ttl = 3600 #Default cache duration for objects when no specific cache-control header is provided.
        max_ttl = 86400 #Maximum cache duration
    }
    price_classs = "priceClass_100" #pricing tiers: PriceClass_100 = lest expensive, PriceClass_200( North American + Europe) = moderate (includes Asia + Oceania), PriceClass_All = Most expensive (all global locations)

    restrictions {
        geo_restriction {
            restriction_type = whitelist #allows specified countries. Optionss are whitelist, blocklist, and none for no restrictions
                locations = var.north_america_restrictions
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

resource "aws_cloudfront_origin_access_identity" "" {
    
}