variable "sns" {
  description = "sns name for ok warning"
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
