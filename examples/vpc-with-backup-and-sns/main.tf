

module "vpc" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//modules/vpc/v2.0.1"
}

module "sns-alarms" {
  source      = "github.com/CloudNation-nl/aws-terraform-modules//modules/sns-alarms/v0.0.1"
  subscribers = ["yannick.vanrooyen@cloudnation.nl"]
}

module "aws-backup" {
  source                      = "github.com/CloudNation-nl/aws-terraform-modules//modules/aws-backup/v0.0.1"
  backup_notifications_enabled = true
  backup_notifications_topic  = module.sns-alarms.sns
  backup_notifications_events = ["BACKUP_JOB_STARTED", "RESTORE_JOB_COMPLETED"]
}