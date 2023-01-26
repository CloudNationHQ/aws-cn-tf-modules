variable "tags" {
  type        = map(any)
  description = "A map of tags assigned to the resource"
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution"
}

variable "description" {
  type        = string
  description = "Any comments you want to include about the distribution."
}

variable "alb_dns_name" {
  type        = string
  description = "The DNS domain name in ALB."
}

variable "domain_names" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
}

variable "wafv2_arn" {
  type        = string
  default     = null
  description = "A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn."
}

variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record."
}

variable "ssl_support_method" {
  type        = string
  default     = "sni-only"
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
}

variable "minimum_protocol_version" {
  type        = string
  default     = "TLSv1.2_2018"
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
}

variable "restriction_type" {
  type        = string
  default     = "none"
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
}

variable "locations" {
  default     = []
  description = "The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist)."
}