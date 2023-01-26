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
  description = "True; enable deletion protection. False; disable deletion protection"
}
variable "ssl_policy" {
  type        = string
  description = "Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
}
variable "default_certificate_arn" {
  type = string
  description = "ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS"
}

variable "additional_certificate_arns" {
  type = list(string)
}

variable "load_balancer_internal" {
  type = string
  description = "If true, the LB will be internal."
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