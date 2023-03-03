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