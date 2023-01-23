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
