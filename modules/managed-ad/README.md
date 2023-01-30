# Features

- Creates randomized password for AD and store in AWS Secrets Manager
- Create SSM document whether instances need to join by tagging the instance

# Usage

```
module "managed-ad" {
  source                  = "github.com/CloudNation-nl/aws-terraform-modules//managed-ad/v0.0.1"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_directory_service_directory.ad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_secretsmanager_secret.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_association.windows_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.ad_join_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_vpc_dhcp_options.dns_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dns_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_secretsmanager_secret.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_edition"></a> [edition](#input\_edition) | (Optional, for type MicrosoftAD only) The MicrosoftAD edition (Standard or Enterprise). Defaults to Enterprise. | `string` | n/a | yes |
| <a name="input_key"></a> [key](#input\_key) | The tag to apply an SSM document to. | `string` | `"tag:adjoin"` | no |
| <a name="input_name"></a> [name](#input\_name) | The fully qualified name for the directory, such as corp.example.comThe fully qualified name for the directory, such as corp.example.com | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The identifiers of the subnets for the directory servers (2 subnets in 2 different AZs). | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(any)` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD. | `string` | n/a | yes |
| <a name="input_values"></a> [values](#input\_values) | The tag to apply an SSM document to. | `list(string)` | <pre>[<br>  "true"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The identifier of the VPC that the directory is in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_url"></a> [access\_url](#output\_access\_url) | AD access\_url |
| <a name="output_dns_ip_addresses"></a> [dns\_ip\_addresses](#output\_dns\_ip\_addresses) | AD dns\_ip\_addresses |
| <a name="output_id"></a> [id](#output\_id) | AD id |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | AD security\_group\_id |

