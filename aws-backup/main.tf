resource "aws_kms_key" "aws_backup" {
  enable_key_rotation = true
  tags                = var.tags
}

resource "aws_backup_vault" "aws_backup" {
  name        = "backup_vault"
  kms_key_arn = aws_kms_key.aws_backup.arn
  tags        = var.tags
}

resource "aws_backup_selection" "daily" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "daily_backup_selection"
  plan_id      = aws_backup_plan.daily.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "dailybackup"
    value = "true"
  }
}

resource "aws_backup_plan" "daily" {
  name = "daily"

  rule {
    rule_name         = "daily_backup_rule"
    target_vault_name = aws_backup_vault.aws_backup.name
    schedule          = "cron(0 12 ? * * *)"

    lifecycle {
      delete_after = 7
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

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "weeklybackup"
    value = "true"
  }
}

resource "aws_backup_plan" "weekly" {
  name = "weekly"

  rule {
    rule_name         = "weekly_backup_rule"
    target_vault_name = aws_backup_vault.aws_backup.name
    schedule          = "cron(0 12 ? * 1 *)"

    lifecycle {
      delete_after = 31
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

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "monthlybackup"
    value = "true"
  }
}

resource "aws_backup_plan" "monthly" {
  name = "monthly"

  rule {
    rule_name         = "monthly_backup_rule"
    target_vault_name = aws_backup_vault.aws_backup.name
    schedule          = "cron(0 12 1 * ? *)"

    lifecycle {
      delete_after = 366
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
