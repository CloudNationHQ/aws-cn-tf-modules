variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-central-1"
}
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
