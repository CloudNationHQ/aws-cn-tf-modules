variable "tags" {
  type        = map(any)
  default     = null
  description = "Tags to tag all resources with"
}

variable "selection_tag" {
  default     = "backup"
  description = "Tag that is used to target resources to backup"
  type        = string
}

variable "backup_vault_name" {
  default     = "my-backup-vault"
  description = "Name of the backup vault"
  type        = string
}

variable "daily_cron_schedule" {
  default     = "cron(0 12 ? * * *)"
  type        = string
  description = "Cron schedule for daily backups"
}

variable "weekly_cron_schedule" {
  default     = "cron(0 12 ? * 1 *)"
  type        = string
  description = "Cron schedule for weekly backups"
}

variable "monthly_cron_schedule" {
  default     = "cron(0 12 1 * ? *)"
  type        = string
  description = "Cron schedule for monthly backups"
}

variable "daily_backup_lifecycledays" {
  default     = 7
  type        = string
  description = "How many days to store daily backups"
}

variable "weekly_backup_lifecycledays" {
  default     = 31
  type        = string
  description = "How many days to store weekly backups"
}

variable "monthly_backup_lifecycledays" {
  default     = 366
  type        = string
  description = "How many days to store monthly backups"
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

