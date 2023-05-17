data "aws_ssoadmin_instances" "this" {}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = var.account_ids
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = var.permission_set_arn

  principal_id   = var.group_id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}