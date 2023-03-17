variable "tags" {
  type        = map(any)
  default     = null
  description = "Tags to tag all resources with"
}

variable "selection_tag" {
  default     = "backup"
  description = "Tag that is used to target resources to backup"
}

variable "backup_vault_name" {
  default     = "my-backup-vault"
  description = "Name of the backup vault"
}

variable "daily_cron_schedule" {
  default = "cron(0 12 ? * * *)"
}

variable "weekly_cron_schedule" {
  default = "cron(0 12 ? * 1 *)"
}

variable "monthly_cron_schedule" {
  default = "cron(0 12 1 * ? *)"
}

variable "daily_backup_lifecycledays" {
  default = 7
}

variable "weekly_backup_lifecycledays" {
  default = 31
}

variable "monthly_backup_lifecycledays" {
  default = 366
}

variable "backup_notifications_topic" {
  type        = string
  default     = null
  description = "SNS Topic for backup alerts eg. failed backup."
}

variable "backup_notifications_enabled" {
  type        = bool
  default     = false
  description = "Enable if you want to receive notifications. Requires backup_notifications_topic to be set"
}

variable "backup_notifications_events" {
  type = list(string)
  default = [
    "BACKUP_JOB_FAILED",
    "RESTORE_JOB_FAILED",
    "COPY_JOB_FAILED",
    "S3_BACKUP_OBJECT_FAILED",
    "S3_RESTORE_OBJECT_FAILED"
  ]
  description = "Default list of events"
}

