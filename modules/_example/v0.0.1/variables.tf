variable "requiredparameter" {
  description = "Infinidash dashboard name"
  type        = string
}

variable "defaultparameter" {
  description = "Infinidash dashboard description"
  default     = "mydashboard"
  type        = string
}

variable "optionalparameter" {
  description = "Enable Infinidash auth"
  default     = false
  type        = boolean
}
