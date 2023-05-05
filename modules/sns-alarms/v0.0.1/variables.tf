variable "name" {
  description = "sns name for the topic"
  default     = "sns-topic"
}

variable "tags" {
  type    = map(any)
  default = null
}

variable "subscribers" {
  type    = list(string)
  default = []
}
