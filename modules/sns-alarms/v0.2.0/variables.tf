variable "name" {
  description = "sns name for the topic"
  default     = "sns-topic"
  type        = string
}

variable "tags" {
  type        = map(any)
  default     = null
  description = "tags"
}

variable "subscribers" {
  type        = list(string)
  default     = []
  description = "list of email adresses to send notifications to"
}
