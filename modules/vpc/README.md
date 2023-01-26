# Features

- VPC with 3 Availability zones
- Public, Private and Database subnets
- Gateway endpoints to S3 and DynamoDB
- Single NAT Gateway by default for private subnets only
- VPC Flow Logging to S3 configurable

# Usage

```
module "vpc" {
  source                  = "github.com/CloudNation-nl/aws-terraform-modules//vpc/v2.0.1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> v3.19.0 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.kms_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.vpc_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.vpc-bucket-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.vpc_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.dynamodb_endpoint_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list(any)` | `[]` | no |
| <a name="input_cidr_range"></a> [cidr\_range](#input\_cidr\_range) | The CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_create_database_nat_gateway_route"></a> [create\_database\_nat\_gateway\_route](#input\_create\_database\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the database subnets | `bool` | `false` | no |
| <a name="input_database_subnet_group_name"></a> [database\_subnet\_group\_name](#input\_database\_subnet\_group\_name) | Use this to prevent renaming a database subnet when renaming VPC | `string` | `""` | no |
| <a name="input_database_subnet_tags"></a> [database\_subnet\_tags](#input\_database\_subnet\_tags) | A list of database subnet tags | `map(any)` | <pre>{<br>  "Network": "Database"<br>}</pre> | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | A list of database subnets inside the VPC | `list(any)` | `[]` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Boolean to disable/enable VPC flow logging | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | environment name. | `string` | `"dev"` | no |
| <a name="input_flow_log_retention_days"></a> [flow\_log\_retention\_days](#input\_flow\_log\_retention\_days) | VPC flow log bucket lifecycle retention period in days | `number` | `30` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | A list of private subnet tags | `map(any)` | <pre>{<br>  "Network": "Private",<br>  "kubernetes.io/role/internal-elb": "1"<br>}</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(any)` | `[]` | no |
| <a name="input_private_zone_name"></a> [private\_zone\_name](#input\_private\_zone\_name) | private zone name. | `string` | `"example.lan"` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | A list of public subnet tags | `map(any)` | <pre>{<br>  "Network": "Public",<br>  "kubernetes.io/role/elb": "1"<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | n/a |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | n/a |
| <a name="output_private_zone_name"></a> [private\_zone\_name](#output\_private\_zone\_name) | n/a |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | n/a |
| <a name="output_subnet_database_subnet_ids"></a> [subnet\_database\_subnet\_ids](#output\_subnet\_database\_subnet\_ids) | List of IDs of database subnets |
| <a name="output_subnet_database_subnets_cidr_blocks"></a> [subnet\_database\_subnets\_cidr\_blocks](#output\_subnet\_database\_subnets\_cidr\_blocks) | List of cidr\_blocks of database subnets |
| <a name="output_subnet_database_subnets_group_name"></a> [subnet\_database\_subnets\_group\_name](#output\_subnet\_database\_subnets\_group\_name) | List of cidr\_blocks of database subnets |
| <a name="output_subnet_private_subnet_ids"></a> [subnet\_private\_subnet\_ids](#output\_subnet\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_subnet_private_subnets_cidr_blocks"></a> [subnet\_private\_subnets\_cidr\_blocks](#output\_subnet\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_subnet_public_subnet_ids"></a> [subnet\_public\_subnet\_ids](#output\_subnet\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_subnet_public_subnets_cidr_blocks"></a> [subnet\_public\_subnets\_cidr\_blocks](#output\_subnet\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

# CHANGELOG
### v2.0.1
- Made all inputs optional
- Updated README

### v0.0.1
- Initial Commit