# Service
- Deploys an (encrypted) SNS topic
- Policy allows publishing from CloudWatch and AWS Backup
- Allows adding Email Subscribers

# Usage

```
module "sns-alarms" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//modules/sns-alarms/v0.0.1"
}