variable "name" {
  description = "The name to use for the permission set"
  type        = string
}

variable "description" {
  description = "The description of the permission set"
  type        = string
}

variable "session_duration" {
  description = "The session duration associated with this permission set"
  type        = string
  default     = "PT4H"
}

variable "managed_policy_arns" {
  description = "A map of the arns of the managed policies that you would like to associate with this permission set"
  type        = map(string)
}

variable "inline_policy" {
  description = "An inline policy that has to be added to the permission set. Use a valid JSON string as input. If this input is skipped no inline policy is added to the permission set."
  type        = string
  default     = ""
}