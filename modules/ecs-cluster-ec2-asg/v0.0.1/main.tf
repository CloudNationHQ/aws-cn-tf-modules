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
  name = join("-", [substr("EcsInstanceRole-${var.cluster_name}", 0, 59), random_id.code.hex])
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  #checkov:skip=CKV_AWS_290:IAM policy will be set as desired
  #checkov:skip=CKV_AWS_355:IAM policy will be set as desired
  name   = "EcsInstanceRolePolicy-${var.cluster_name}-${random_id.code.hex}"
  role   = aws_iam_role.ecs_instance_role.id
  policy = var.ecs_instance_role_policy
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = join("-", [substr("EcsInstanceProfile-${var.cluster_name}", 0, 59), random_id.code.hex])
  role = aws_iam_role.ecs_instance_role.name
}

# Create ECS IAM Service Role and Policy
resource "aws_iam_role" "ecs_service_role" {
  name               = "EcsServiceRole-${var.cluster_name}-${random_id.code.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
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
  image_id               = var.ami_id == "" ? data.aws_ami.ecs_ami.id : var.ami_id
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
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  termination_policies      = var.termination_policies
  protect_from_scale_in     = var.protect_from_scale_in
  # To enable managed termination protection for a capacity provider, the Auto Scaling group must have instance protection from scale in enabled.

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


  lifecycle {
    create_before_destroy = true
  }
}

# Create capacity provider
# Reference: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html
resource "aws_ecs_capacity_provider" "this" {
  # The capacity provider name can have up to 255 characters, including letters (upper and lowercase), numbers, underscores, and hyphens.
  # The name cannot be prefixed with "aws", "ecs", or "fargate".
  name = join("-", ["cp", var.cluster_name])

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this.arn
    # managed_termination_protection = "ENABLED"
    managed_termination_protection = "DISABLED"

    managed_scaling {
      instance_warmup_period    = 120 # Default is 300
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}
