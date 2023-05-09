output "arn" {
  value       = aws_ecr_repository.this.arn
  description = "Repository ARN"
}

output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "Repository URL"
}

output "kms_key_id" {
  value       = aws_kms_key.this[*].key_id
  description = "KMS Key ID"
}

output "kms_key_arn" {
  value       = aws_kms_key.this[*].arn
  description = "KMS key ARN"
}