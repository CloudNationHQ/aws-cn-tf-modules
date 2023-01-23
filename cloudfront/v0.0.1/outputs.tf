output "cloudfront_arn" {
  description = "arn of cloudfront"
  value       = aws_cloudfront_distribution.cf_dist.arn
}