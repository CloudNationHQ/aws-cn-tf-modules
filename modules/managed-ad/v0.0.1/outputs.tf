output "id" {
  description = "AD id"
  value       = aws_directory_service_directory.ad.id
}

output "access_url" {
  description = "AD access_url"
  value       = aws_directory_service_directory.ad.access_url
}

output "dns_ip_addresses" {
  description = "AD dns_ip_addresses"
  value       = aws_directory_service_directory.ad.dns_ip_addresses
}

output "security_group_id" {
  description = "AD security_group_id"
  value       = aws_directory_service_directory.ad.security_group_id
} 