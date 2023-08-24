resource "aws_ecr_registry_scanning_configuration" "this" {
  count     = var.enable_registry_scanning ? 1 : 0
  scan_type = "ENHANCED"

  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }

  rule {
    scan_frequency = "CONTINUOUS_SCAN"
    dynamic "repository_filter" {
      for_each = var.continuous_scan_filter
      content {
        filter      = repository_filter.value
        filter_type = "WILDCARD"
      }
    }
  }
}