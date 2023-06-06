locals {
  # Generate user_data from template file
  user_data = templatefile("${path.module}/default_user_data.sh", {
    ecs_cluster_name = var.cluster_name
  })
}
