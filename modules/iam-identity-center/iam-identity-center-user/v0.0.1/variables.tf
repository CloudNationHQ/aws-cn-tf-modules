variable "email" {
  description = "The email of the user, this will be used as well to set the user_name"
  type        = string
}

variable "given_name" {
  description = "The first name of the user"
  type        = string
}

variable "family_name" {
  description = "The last name of the user"
  type        = string
}

variable "groups" {
  description = "the groups to which the user has to be added as a member"
  type        = map(string)
  default     = {}
}