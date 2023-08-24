resource "aws_kms_key" "aws_backup" {
  enable_key_rotation = true
  tags                = var.tags
}

resource "aws_backup_vault" "aws_backup" {
  name        = var.backup_vault_name
  kms_key_arn = aws_kms_key.aws_backup.arn
  tags        = var.tags
}

resource "aws_backup_selection" "daily" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "daily_backup_selection"
  plan_id      = aws_backup_plan.daily.id
  resources    = ["*"]
  condition {
    string_like {
      key   = "aws:ResourceTag/${var.selection_tag}"
      value = "*daily*"
    }
  }
}

resource "aws_backup_plan" "daily" {
  name = "${var.backup_vault_name}-daily"

  rule {
    rule_name                = "daily_backup_rule"
    target_vault_name        = aws_backup_vault.aws_backup.name
    schedule                 = var.daily_cron_schedule
    enable_continuous_backup = var.enable_continuous_backup

    lifecycle {
      delete_after = var.daily_backup_lifecycledays
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_selection" "weekly" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "weekly_backup_selection"
  plan_id      = aws_backup_plan.weekly.id
  resources    = ["*"]
  condition {
    string_like {
      key   = "aws:ResourceTag/${var.selection_tag}"
      value = "*weekly*"
    }
  }
}

resource "aws_backup_plan" "weekly" {
  name = "${var.backup_vault_name}-weekly"

  rule {
    rule_name         = "weekly_backup_rule"
    target_vault_name = aws_backup_vault.aws_backup.name
    schedule          = var.weekly_cron_schedule

    lifecycle {
      delete_after = var.weekly_backup_lifecycledays
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_selection" "monthly" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "monthly_backup_selection"
  plan_id      = aws_backup_plan.monthly.id
  resources    = ["*"]
  condition {
    string_like {
      key   = "aws:ResourceTag/${var.selection_tag}"
      value = "*monthly*"
    }
  }
}

resource "aws_backup_plan" "monthly" {
  name = "${var.backup_vault_name}-monthly"

  rule {
    rule_name         = "monthly_backup_rule"
    target_vault_name = aws_backup_vault.aws_backup.name
    schedule          = var.monthly_cron_schedule

    lifecycle {
      delete_after = var.monthly_backup_lifecycledays
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_iam_role" "aws_backup" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup.name
}

resource "aws_backup_vault_notifications" "vault_notifications" {
  count               = var.backup_notifications_enabled ? 1 : 0
  backup_vault_name   = aws_backup_vault.aws_backup.name
  sns_topic_arn       = var.backup_notifications_topic
  backup_vault_events = var.backup_notifications_events
}

resource "aws_backup_vault_lock_configuration" "vault_lock" {
  count = var.vault_lock_enabled == true ? 1 : 0
  backup_vault_name   = aws_backup_vault.aws_backup.name
  changeable_for_days = var.vault_lock_changeable_for_days
  max_retention_days  = var.vault_lock_max_retention_days
  min_retention_days  = var.vault_lock_min_retention_days
}