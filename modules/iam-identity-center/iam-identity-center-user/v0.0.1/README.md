<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email"></a> [email](#input\_email) | The email of the user, this will be used as well to set the user\_name | `string` | n/a | yes |
| <a name="input_family_name"></a> [family\_name](#input\_family\_name) | The last name of the user | `string` | n/a | yes |
| <a name="input_given_name"></a> [given\_name](#input\_given\_name) | The first name of the user | `string` | n/a | yes |
| <a name="input_groups"></a> [groups](#input\_groups) | the groups to which the user has to be added as a member | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->