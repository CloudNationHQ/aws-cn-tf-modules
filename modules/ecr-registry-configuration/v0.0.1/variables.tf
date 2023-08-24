variable "enable_registry_scanning" {
  type        = bool
  default     = true
  description = "Enable registry scanning"
}

variable "continuous_scan_filter" {
  type        = list(string)
  default     = ["*"]
  description = "List of glob patterns to match against the image name. If the image name matches any of the patterns, the image will be scanned continuously. Default is wildcard"
}