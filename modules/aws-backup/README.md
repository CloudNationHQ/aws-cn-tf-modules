# Service
- Deploys an AWS Backup vault and a daily, weekly and monthly backup plan.
- Cron expression, vault name and selectiontag are configurable
- To backup a resource, tag it with the `selection_tag` and add the plans you want to use as value e.g. "daily,weekly"

# Usage

```
module "aws-backup" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//modules/aws-backup/v0.0.1"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.weekly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.weekly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.aws_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_notifications.vault_failed_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications) | resource |
| [aws_iam_role.aws_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.aws_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_notifications_enabled"></a> [backup\_notifications\_enabled](#input\_backup\_notifications\_enabled) | Toggle for SNS notifications on fail backup events | `bool` | `false` | no |
| <a name="input_backup_notifications_events"></a> [backup\_notifications\_events](#input\_backup\_notifications\_events) | Default list of events | `list(string)` | <pre>[<br>  "BACKUP_JOB_FAILED",<br>  "RESTORE_JOB_FAILED",<br>  "COPY_JOB_FAILED",<br>  "S3_BACKUP_OBJECT_FAILED",<br>  "S3_RESTORE_OBJECT_FAILED"<br>]</pre> | no |
| <a name="input_backup_notifications_topic"></a> [backup\_notifications\_topic](#input\_backup\_notifications\_topic) | SNS Topic for backup alerts eg. failed backup. It's advised to use a centralized topic in a Shared account | `string` | `null` | no |
| <a name="input_backup_vault_name"></a> [backup\_vault\_name](#input\_backup\_vault\_name) | n/a | `string` | `"my-backup-vault"` | no |
| <a name="input_daily_backup_lifecycledays"></a> [daily\_backup\_lifecycledays](#input\_daily\_backup\_lifecycledays) | n/a | `number` | `7` | no |
| <a name="input_daily_cron_schedule"></a> [daily\_cron\_schedule](#input\_daily\_cron\_schedule) | n/a | `string` | `"cron(0 12 ? * * *)"` | no |
| <a name="input_monthly_backup_lifecycledays"></a> [monthly\_backup\_lifecycledays](#input\_monthly\_backup\_lifecycledays) | n/a | `number` | `366` | no |
| <a name="input_monthly_cron_schedule"></a> [monthly\_cron\_schedule](#input\_monthly\_cron\_schedule) | n/a | `string` | `"cron(0 12 1 * ? *)"` | no |
| <a name="input_selection_tag"></a> [selection\_tag](#input\_selection\_tag) | n/a | `string` | `"backup"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `null` | no |
| <a name="input_weekly_backup_lifecycledays"></a> [weekly\_backup\_lifecycledays](#input\_weekly\_backup\_lifecycledays) | n/a | `number` | `31` | no |
| <a name="input_weekly_cron_schedule"></a> [weekly\_cron\_schedule](#input\_weekly\_cron\_schedule) | n/a | `string` | `"cron(0 12 ? * 1 *)"` | no |

## Outputs

No outputs.


# CHANGELOG

v0.0.1
- Initial Commit
- SNS notification for Backup events