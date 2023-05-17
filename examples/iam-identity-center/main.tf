
module "engineer_group" {
  source       = "../../modules/iam-identity-center/iam-identity-center-group/v0.0.1"
  display_name = "engineer"
  description  = "All engineers will be in this group"
}

module "john_doe" {
  source      = "../../modules/iam-identity-center/iam-identity-center-user/v0.0.1"
  email       = "john@email.com"
  given_name  = "John"
  family_name = "Doe"
  groups = {
    engineer = module.engineer_group.group_id
  }
}

module "power_user_permission_set" {
  source      = "../../modules/iam-identity-center/iam-identity-center-permission-set/v0.0.1"
  name        = "power-user-access"
  description = "permission set for power user access"
  managed_policy_arns = {
    power_user = "arn:aws:iam::aws:policy/PowerUserAccess"
  }
}

module "engineer_power_user_assignment" {
  source             = "../../modules/iam-identity-center/iam-identity-center-group-assignment/v0.0.1"
  permission_set_arn = module.power_user_permission_set.permission_set_arn
  group_id           = module.engineer_group.group_id
  account_ids = {
    management = "111213141516" #replace this value with your desired AWS account id
  }
}