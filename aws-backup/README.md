# AWS Backup

Make sure instances have the tag value:

- dailybackup:true ([Optional] if EC2 tagged, daily backups enabled)
- weeklybackup:true ([Optional] if EC2 tagged, weekly backups enabled)
- monthlybackup:true ([Optional] if EC2 tagged, monthly backups enabled)

## Usage
module "aws-backup" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//aws-backup/v0.0.1"
  tags   = local.tags (Use local tags to tag this service)
}
