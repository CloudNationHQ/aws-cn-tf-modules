variable "tags" {
  type    = map(any)
  default = null
}

variable "selection_tag" {
  default = "backup"
}

variable "backup_vault_name" {
  default = "my-backup-vault"
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
  description = "SNS Topic for backup alerts eg. failed backup. It's advised to use a centralized topic in a Shared account"
}

variable "backup_notifications_enabled" {
  type = bool
  default = false
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

