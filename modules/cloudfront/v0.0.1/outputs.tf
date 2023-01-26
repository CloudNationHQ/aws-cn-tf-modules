output "cloudfront_arn" {
  description = "arn of cloudfront"
  value       = aws_cloudfront_distribution.cf_dist.arn
}

output "domain_name" {
  description = "The domain name corresponding to the distribution"
  value       = aws_cloudfront_distribution.cf_dist.domain_name
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID"
  value       = aws_cloudfront_distribution.cf_dist.hosted_zone_id
}
