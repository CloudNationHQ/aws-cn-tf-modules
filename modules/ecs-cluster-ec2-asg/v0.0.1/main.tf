# Create KMS key
resource "aws_kms_key" "this" {
  description             = "ECS Cluster ${var.cluster_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/ecs/cluster/${var.cluster_name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = jsonencode({
    Id = "KMSKeyPolicy"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${data.aws_region.current.name}.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnLike" : {
            "kms:EncryptionContext:aws:logs:arn" : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/ECS/Cluster/${var.cluster_name}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ssm.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_cloudwatch_log_group" "this" {
  #checkov:skip=CKV_AWS_338:CloudWatch log groups log retention will be set to the desired period
  depends_on = [
    aws_kms_key_policy.this
  ]
  name              = "/ECS/Cluster/${var.cluster_name}"
  retention_in_days = var.cloudwatch_log_retention
  kms_key_id        = aws_kms_key.this.arn
  tags              = var.tags
}

# Create ECS cluster
resource "aws_ecs_cluster" "this" {
  #checkov:skip=CKV_AWS_65:Container Insights will be enabled when required
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.this.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }
  tags = var.tags
}

# Create ECS IAM Instance Role and Policy
resource "random_id" "code" {
  byte_length = 4
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "EcsInstanceRole-${var.cluster_name}-${random_id.code.hex}"
  assume_role_policy = var.ecs_instance_role_assume_role_policy
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  #checkov:skip=CKV_AWS_290:IAM policy will be set as desired
  #checkov:skip=CKV_AWS_355:IAM policy will be set as desired
  name   = "EcsInstanceRolePolicy-${var.cluster_name}-${random_id.code.hex}"
  role   = aws_iam_role.ecs_instance_role.id
  policy = var.ecs_instance_role_policy
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile-${var.cluster_name}-${random_id.code.hex}"
  role = aws_iam_role.ecs_instance_role.name
}

# Create ECS IAM Service Role and Policy
resource "aws_iam_role" "ecs_service_role" {
  name               = "EcsServiceRole-${var.cluster_name}-${random_id.code.hex}"
  assume_role_policy = var.ecs_service_role_assume_role_policy
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  #checkov:skip=CKV_AWS_290:IAM policy will be set as desired
  #checkov:skip=CKV_AWS_355:IAM policy will be set as desired
  name   = "EcsServiceRolePolicy-${var.cluster_name}-${random_id.code.hex}"
  role   = aws_iam_role.ecs_service_role.id
  policy = var.ecs_service_role_policy
}

# Create Launch Template
resource "aws_launch_template" "this" {
  default_version        = 1
  ebs_optimized          = false
  name                   = "lt-${var.cluster_name}"
  image_id               = data.aws_ami.ecs_ami.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = var.security_group_ids
  user_data              = base64encode(var.user_data != "false" ? var.user_data : local.user_data)

  metadata_options {
    # Enable Instance Metadata Service V2 
    http_tokens = "required"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.id
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "network-interface"
    tags          = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }
}

# Create Auto-Scaling Group
resource "aws_autoscaling_group" "this" {
  name                      = var.cluster_name
  vpc_zone_identifier       = var.subnet_ids
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  termination_policies      = var.termination_policies

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "ecs_cluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  protect_from_scale_in = var.protect_from_scale_in

  lifecycle {
    create_before_destroy = true
  }
}

# Create autoscaling policies
resource "aws_autoscaling_policy" "up" {
  count                  = var.alarm_actions_enabled ? 1 : 0
  name                   = "${var.cluster_name}-ScaleUp"
  scaling_adjustment     = var.scaling_adjustment_up
  adjustment_type        = var.adjustment_type
  cooldown               = var.policy_cooldown
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "down" {
  count                  = var.alarm_actions_enabled ? 1 : 0
  name                   = "${var.cluster_name}-ScaleDown"
  scaling_adjustment     = var.scaling_adjustment_down
  adjustment_type        = var.adjustment_type
  cooldown               = var.policy_cooldown
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
}

# Create CloudWatch alarms to trigger scaling of ASG
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  count               = var.alarm_actions_enabled ? 1 : 0
  alarm_name          = "${var.cluster_name}-ScaleUp"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = var.alarm_period
  threshold           = var.alarm_threshold_scale_up
  actions_enabled     = var.alarm_actions_enabled
  alarm_actions       = [aws_autoscaling_policy.up[0].arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  count               = var.alarm_actions_enabled ? 1 : 0
  alarm_name          = "${var.cluster_name}-ScaleDown"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = var.alarm_period
  threshold           = var.alarm_threshold_scale_down
  actions_enabled     = var.alarm_actions_enabled
  alarm_actions       = [aws_autoscaling_policy.down[0].arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}
