output "permission_set_arn" {
  value       = aws_ssoadmin_permission_set.this.arn
  description = "The arn of the IAM Identity Center permission set"
}