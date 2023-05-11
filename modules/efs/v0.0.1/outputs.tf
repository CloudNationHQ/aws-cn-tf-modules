output "efs_file_system_id" {
  value       = aws_efs_file_system.efs.id
  description = "EFS File system ID"
}

output "efs_file_system_arn" {
  value       = aws_efs_file_system.efs.arn
  description = "EFS File system ARN"
}

output "efs_file_system_dns_name" {
  value       = aws_efs_file_system.efs.dns_name
  description = "EFS File system DNS Name"
}

output "efs_file_system_security_group_id" {
  value       = aws_security_group.security-group.id
  description = "EFS File system Security Group ID"
}

output "efs_file_system_security_group_arn" {
  value       = aws_security_group.security-group.arn
  description = "EFS File system Security Group Arn"
}