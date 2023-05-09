variable "name" {
  default     = "my-ecr-repo"
  description = "Name for the ECR Repo"
  type        = string
}
variable "mutability" {
  default     = "MUTABLE"
  description = "MUTABLE or IMMUTABLE"
  type        = string
}
variable "kms_encryption" {
  default     = false
  description = "Enables KMS encryption for the repo. Default is AES256"
  type        = bool
}
variable "force_delete" {
  default     = false
  description = "When enabled, you can delete the repository when there are images inside."
  type        = bool
}
variable "tags" {
  default     = null
  description = "tags that are added to the repository (and KMS keys)"
  type        = map(any)
}

variable "allowed_principals" {
  default     = null
  description = "List of AWS account IDs or ARNs that are allowed to pull images"
  type        = list(any)
}

variable "lifecycle_policy" {
  default     = null
  description = "Lifecycle policy IAM document"
  type        = string
}