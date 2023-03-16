output "sns" {
  description = "SNS ARN"
  value       = aws_sns_topic.sns.arn
}