data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.name
  description      = var.description
  instance_arn     = local.identity_store_arn
  session_duration = var.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each           = var.managed_policy_arns
  instance_arn       = local.identity_store_arn
  managed_policy_arn = each.value
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}

# data "aws_iam_policy_document" "this" {
#   statement {
#     sid = "1"

#     actions = [
#       "s3:ListAllMyBuckets",
#       "s3:GetBucketLocation",
#     ]

#     resources = [
#       "arn:aws:s3:::*",
#     ]
#   }
# }

# resource "aws_ssoadmin_permission_set_inline_policy" "example" {
#   inline_policy      = data.aws_iam_policy_document.this.json
#   instance_arn       = local.identity_store_id
#   permission_set_arn = aws_ssoadmin_permission_set.this.arn
# }