ECS Cluster

# Features

- ECS Cluster
- Container Insights disabled by default
- ECS Execute Command logging configuration enforced

# Usage

```
module "ecs-cluster" {
  source         = "github.com/CloudNation-nl/aws-terraform-modules//modules/ecs-cluster/v0.0.1"
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.60.0 |


## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | CloudWatch log group retention in days | `number` | `7` | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | Enable or disable Container Insights | `string` | `"disabled"` | no |
| <a name="input_name"></a> [name](#input\_name) | ECS Cluster Name | `string` | `"cluster"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ECS Cluster Arn |
| <a name="output_id"></a> [id](#output\_id) | ECS Cluster id |

# CHANGELOG

v0.0.1
- Added ECS Cluster with encrypted ECS Execute Command logging config