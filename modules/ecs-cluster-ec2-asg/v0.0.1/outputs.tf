output "asg_id" {
  description = "Autoscaling group ID"
  value       = aws_autoscaling_group.this.id
}

output "asg_arn" {
  description = "Autoscaling group ARN"
  value       = aws_autoscaling_group.this.arn
}

output "asg_launch_template_id" {
  description = "Autoscaling group launch template ID"
  value       = aws_launch_template.this.id
}

output "ecs_ami_id" {
  description = "ECS instance AMI ID"
  value       = data.aws_ami.ecs_ami.id
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "ecs_instance_profile_id" {
  description = "ECS instance profile ID"
  value       = aws_iam_instance_profile.ecs_instance_profile.id
}

output "ecs_instance_role_arn" {
  description = "ECS instance role ARN"
  value       = aws_iam_role.ecs_instance_role.arn
}

output "ecs_service_role_arn" {
  description = "ECS service role ARN"
  value       = aws_iam_role.ecs_service_role.arn
}
