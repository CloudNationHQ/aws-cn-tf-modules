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

variable "zone_id" {
  type = string
}

variable "ssl_support_method" {
  type = string
  default = "sni-only"
}

variable "minimum_protocol_version" {
  type = string
  default = "TLSv1.2_2018"
}