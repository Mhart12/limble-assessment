data "aws_acm_certificate" "default" {
  provider = aws.us-east-1
  domain   = "*.assessment-sandbox.com"
}

# Cloudfront Distribution using Limble ALB as origin
resource "aws_cloudfront_distribution" "default" {
  aliases = ["ecs.assessment-sandbox.com"]

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = data.aws_ssm_parameter.alb_dns_name.value
    origin_id           = data.aws_ssm_parameter.alb_dns_name.value

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_read_timeout    = 30
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  price_class     = "PriceClass_100"

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = data.aws_ssm_parameter.alb_dns_name.value
    viewer_protocol_policy   = "https-only"
    cache_policy_id          = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    compress                 = true

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.default.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Name       = "${var.name}-wordpress-cdn"
    assessment = var.name
  }
}
