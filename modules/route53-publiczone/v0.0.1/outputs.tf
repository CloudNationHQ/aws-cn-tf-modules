output "public_zone_id" {
  value       = aws_route53_zone.public.zone_id
  description = "Public zone ID"
}

output "public_name_servers" {
  value       = aws_route53_zone.public.name_servers
  description = "Name servers that host this zone"
}
