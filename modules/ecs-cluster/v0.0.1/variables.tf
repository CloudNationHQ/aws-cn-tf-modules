variable "name" {
  description = "ECS Cluster Name"
  default     = "cluster"
  type        = string
}

variable "container_insights" {
  description = "Enable or disable Container Insights"
  default     = "disabled"
  type        = string
}

variable "cloudwatch_log_retention" {
  default     = 7
  type        = number
  description = "CloudWatch log group retention in days"
}

variable "tags" {
  type    = map(any)
  default = null
}