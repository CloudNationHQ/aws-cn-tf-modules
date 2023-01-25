resource "aws_route53_record" "public_record" {
  zone_id = var.zone_id
  name    = var.domain_names[0]
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.cf_dist.domain_name
    zone_id = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = true
  }

}
