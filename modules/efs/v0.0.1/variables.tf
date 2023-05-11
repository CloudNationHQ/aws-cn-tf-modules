variable "tags" {
  default     = null
  description = "Map of Tags"
  type        = map(any)
}

variable "subnet_ids" {
  type        = list(any)
  description = "The 3 subnet IDs to deploy the EFS filesystem to"
}

variable "allowed_security_groups" {
  description = "security groups allowed for ingress"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
    description     = string
  }))
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "name" {
  default     = "EFS"
  type        = string
  description = "Filesystem name"
}

variable "throughput_mode" {
  default     = null
  type        = string
  description = "bursting, provisioned, or elastic"
}

variable "performance_mode" {
  default     = null
  type        = string
  description = "generalPurpose or maxIO"
}

variable "provisioned_throughput_in_mibps" {
  default     = null
  type        = number
  description = "For provisioned throughput only"
}

variable "lifecycle_policies" {
  description = "Lifecycle Policies"
  type        = map(any)
  default = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
}