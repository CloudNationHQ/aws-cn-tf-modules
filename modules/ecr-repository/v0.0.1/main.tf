resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.mutability

  encryption_configuration {
    encryption_type = var.kms_encryption == true ? "KMS" : "AES256"
    kms_key         = var.kms_encryption == true ? aws_kms_key.this[0].arn : null
  }
  force_delete = var.force_delete
  tags         = var.tags
}

data "aws_iam_policy_document" "this_policy" {
  count = var.allowed_principals != null ? 1 : 0
  statement {
    sid    = "AllowPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_principals
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.allowed_principals != null ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this_policy[0].json
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy != null ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = jsonencode(var.lifecycle_policy)
}

resource "aws_kms_key" "this" {
  count               = var.kms_encryption == true ? 1 : 0
  enable_key_rotation = true
  tags                = var.tags
}

resource "aws_kms_alias" "this" {
  count         = var.kms_encryption == true ? 1 : 0
  name          = "alias/ecr/repository/${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}