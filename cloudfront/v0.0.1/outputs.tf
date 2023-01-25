output "cloudfront_arn" {
  description = "arn of cloudfront"
  value       = aws_cloudfront_distribution.cf_dist.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.cf_dist.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.cf_dist.hosted_zone_id
}
