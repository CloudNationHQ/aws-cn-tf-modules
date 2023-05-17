variable "permission_set_arn" {
  description = "The arn of the permission set to be assigned to the account ids"
  type        = string
}

variable "group_id" {
  description = "The id of the group to be assigned to the account ids"
  type        = string
}

variable "account_ids" {
  description = "The account ids scoped for the assignment"
  type        = map(string)
}
