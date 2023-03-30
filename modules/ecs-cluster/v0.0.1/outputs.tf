output "arn" {
  description = "ECS Cluster Arn"
  value       = aws_ecs_cluster.this.arn
}

output "id" {
  description = "ECS Cluster id"
  value       = aws_ecs_cluster.this.id
}