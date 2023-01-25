output "https_listener_arn" {
  description = "HTTPS listener arn"
  value       = aws_lb_listener.https.arn
}

output "loadbalancer_arn" {
  description = "loadbalancer arn"
  value       = aws_lb.loadbalancer.arn
}

output "dns_name" {
  description = "dns name"
  value       = aws_lb.loadbalancer.dns_name
}

output "security_group" {
  description = "security_group"
  value       = aws_security_group.allow_lb[*].id
}

output "security_group_cf" {
  description = "security_group"
  value       = aws_security_group.allow_lb_cf[*].id
}

