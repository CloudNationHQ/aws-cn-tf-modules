data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "sns" {
  name              = var.name
  kms_master_key_id = aws_kms_key.this.arn
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "alarms_mail_subscriber" {
  for_each  = toset(var.subscribers)
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.sns.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.sns.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow AWS Backup"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.sns.arn]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow SES"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.sns.arn]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:ses:*"]
    }

  }

}

data "aws_iam_policy_document" "kms_key" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow CloudWatch to use KMS"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey*"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow AWS Backup to use KMS"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey*"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow SES to use KMS"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey*"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
  }

}

resource "aws_kms_key" "this" {
  tags                = var.tags
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "this" {
  name_prefix   = "alias/sns/topic/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}
