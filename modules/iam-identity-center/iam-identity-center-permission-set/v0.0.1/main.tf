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

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  # only create an inline policy if the value of the input variable is not empty
  count              = var.inline_policy == "" ? 0 : 1
  inline_policy      = var.inline_policy
  instance_arn       = local.identity_store_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}