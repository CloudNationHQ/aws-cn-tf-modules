variable "name" {
  description = "name"
}
variable "vpc_id" {
  description = "vpc id"
}
variable "subnet_ids" {
  description = "subnet id"
}
variable "enable_deletion_protection" {
  type        = string
  description = "(optional) describe your variable"
}
variable "ssl_policy" {
  type        = string
  description = "(optional) describe your variable"
}
variable "default_certificate_arn" {
  type = string
}

variable "additional_certificate_arns" {
  type = list(string)
}

variable "load_balancer_internal" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "cloudfront" {
  type        = bool
  description = "is cloudfront infront of alb, set true, if not, set false"
}

variable "access_logs" {
  type        = bool
  description = "enable access logs, set to true, if not, set to false"
  default     = false
}