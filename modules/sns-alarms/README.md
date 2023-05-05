# Service
- Deploys an (encrypted) SNS topic
- Policy allows publishing from CloudWatch and AWS Backup
- Allows adding Email Subscribers

# Usage

```
module "sns-alarms" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//modules/sns-alarms/v0.0.1"
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.alarms_mail_subscriber](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create things in. | `string` | `"eu-central-1"` | no |
| <a name="input_name"></a> [sns](#input\_sns) | sns name for the topic | `string` | `"sns-topic"` | no |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | n/a | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns"></a> [sns](#output\_sns) | SNS ARN |

# CHANGELOG

v0.0.1
- Initial Commit