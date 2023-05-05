variable "name" {
  default     = "my-ecr-repo"
  description = "Name for the ECR Repo"
}
variable "mutability" {
  default     = "MUTABLE"
  description = "MUTABLE or IMMUTABLE"
}
variable "kms_encryption" {
  default     = false
  description = "Enables KMS encryption for the repo. Default is AES256"
}
variable "force_delete" {
  default     = false
  description = "When enabled, you can delete the repository when there are images inside."
}
variable "tags" {
  default     = null
  description = "tags that are added to the repository (and KMS keys)"
}

variable "allowed_principals" {
  default     = null
  description = "List of AWS account IDs or ARNs that are allowed to pull images"
}

variable "lifecycle_policy" {
  default     = null
  description = "Lifecycle policy IAM document"
}