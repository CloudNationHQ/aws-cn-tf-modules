output "sns" {
  description = "SNS ARN - Legacy"
  value       = aws_sns_topic.sns.arn
}

output "topic_arn" {
  description = "SNS Topic ARN"
  value       = aws_sns_topic.sns.arn
}