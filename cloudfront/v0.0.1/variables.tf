variable "tags" {
  type = map(any)
}

variable "certificate_arn" {
  type = string
}

variable "description" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "wafv2_arn" {
  type    = string
  default = null
}

