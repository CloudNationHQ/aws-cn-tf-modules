data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_user" "this" {
  user_name    = var.email
  display_name = "${var.given_name} ${var.family_name}"
  name {
    given_name  = var.given_name
    family_name = var.family_name
  }

  emails {
    value = var.email
  }

  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group_membership" "this" {
  for_each          = var.groups
  identity_store_id = local.identity_store_id
  group_id          = each.value
  member_id         = aws_identitystore_user.this.user_id
}