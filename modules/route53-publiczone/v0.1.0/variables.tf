variable "public_zone_name" {
  type        = string
  description = "Name for the public zone, e.g. example.com"
}

variable "tags" {
  type        = map(any)
  default     = null
  description = "tags"
}

variable "dnssec" {
  type        = bool
  default     = false
  description = "Enable DNSSEC"
}