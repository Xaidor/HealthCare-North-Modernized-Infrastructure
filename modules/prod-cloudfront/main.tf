resource "aws_cloudfront_distribution" "HealthCare_CF_Distribution" {
    origin {
        domain_name = var.cf_domain_name
        origin_id   = local.cf_origin_id   
    }
    enabled             = true  
    comment             = "HealthCare North CloudFront Disribution"
    default_root_object = "index.html"

    default_cache_behavior {
        target_origin_id       = local.cf_origin_id 
        viewer_protocol_policy = "redirect-to-https" 

        allowed_methods = ["GET", "HEAD"]
        cached_methods  = ["GET", "HEAD"] #common for static content

        forwarded_values {
            query_string = false 

            cookies {
                forward = "none" 
            }
        }
        min_ttl = 0 
        
    }
    price_class = "PriceClass_100" #pricing tiers: PriceClass_100 = lest expensive, PriceClass_200( North American + Europe) = moderate (includes Asia + Oceania), PriceClass_All = Most expensive (all global locations)

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"    #allows specified countries. Optionss are whitelist, blocklist, and none for no restrictions
                locations = ["US", "CA", "MX"]
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}