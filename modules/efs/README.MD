EFS Filesystem

# Features

- Filesystem with full configurability
- Encryption enforced

# Usage

```
module "efs" {
  source          = "github.com/CloudNation-nl/aws-terraform-modules//modules/efs/v0.0.1"
  name            = "my-filesystem"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_private_subnet_ids
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_target_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_efs_mount_target.mount_target_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_efs_mount_target.mount_target_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_kms_key.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | security groups allowed for ingress | <pre>list(object({<br>    from_port       = number<br>    to_port         = number<br>    protocol        = string<br>    security_groups = list(string)<br>    description     = string<br>  }))</pre> | n/a | yes |
| <a name="input_lifecycle_policies"></a> [lifecycle\_policies](#input\_lifecycle\_policies) | Lifecycle Policies | `map(any)` | <pre>{<br>  "transition_to_ia": "AFTER_30_DAYS",<br>  "transition_to_primary_storage_class": "AFTER_1_ACCESS"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Filesystem name | `string` | `"EFS"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | generalPurpose or maxIO | `string` | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | For provisioned throughput only | `number` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The 3 subnet IDs to deploy the EFS filesystem to | `list(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of Tags | `map(any)` | `null` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | bursting, provisioned, or elastic | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_file_system_arn"></a> [efs\_file\_system\_arn](#output\_efs\_file\_system\_arn) | EFS File system ARN |
| <a name="output_efs_file_system_dns_name"></a> [efs\_file\_system\_dns\_name](#output\_efs\_file\_system\_dns\_name) | EFS File system DNS Name |
| <a name="output_efs_file_system_id"></a> [efs\_file\_system\_id](#output\_efs\_file\_system\_id) | EFS File system ID |
| <a name="output_efs_file_system_security_group_arn"></a> [efs\_file\_system\_security\_group\_arn](#output\_efs\_file\_system\_security\_group\_arn) | EFS File system Security Group Arn |
| <a name="output_efs_file_system_security_group_id"></a> [efs\_file\_system\_security\_group\_id](#output\_efs\_file\_system\_security\_group\_id) | EFS File system Security Group ID |
# CHANGELOG

v0.0.1
- Initial version