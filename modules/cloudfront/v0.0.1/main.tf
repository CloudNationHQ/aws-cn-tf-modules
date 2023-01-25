resource "aws_cloudfront_distribution" "cf_dist" {
  enabled    = true
  aliases    = var.domain_names
  comment    = var.description
  web_acl_id = var.wafv2_arn
  origin {
    domain_name = var.alb_dns_name
    origin_id   = var.alb_dns_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_dns_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = ["*"]
      query_string = true

      cookies {
        forward = "all"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }

  tags = var.tags

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }
}