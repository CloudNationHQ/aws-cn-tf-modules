output "arn" {
  description = "Infinidash dashboard arn"
  value       = aws_infinidash_dashboard.example.arn
}

output "name" {
  description = "Infinidash dashboard name"
  value       = aws_infinidash_dashboard.example.name
}

output "authkey" {
  count       = var.optionalresource ? 1 : 0
  description = "Infinidash auth key"
  value       = aws_infinidash_auth.example[*].key
}
