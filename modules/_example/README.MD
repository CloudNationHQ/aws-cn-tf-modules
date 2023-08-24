Example resource to demonstrate requirements. 

# Features

- Resource with a required and optional parameter
- Additional parameter that defaults to false

# Usage

```
module "example" {
  source         = "github.com/CloudNationHQ/aws-cn-tf-modules//modules/example/v0.0.1"
  requiredparam  = "value"
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_infinidash_auth.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/infinidash_auth) | resource |
| [aws_infinidash_dashboard.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/infinidash_dashboard) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_defaultparameter"></a> [defaultparameter](#input\_defaultparameter) | Infinidash dashboard description | `string` | `"mydashboard"` | no |
| <a name="input_optionalparameter"></a> [optionalparameter](#input\_optionalparameter) | Enable Infinidash auth | `bool` | `false` | no |
| <a name="input_requiredparameter"></a> [requiredparameter](#input\_requiredparameter) | Infinidash dashboard name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Infinidash dashboard arn |
| <a name="output_authkey"></a> [authkey](#output\_authkey) | Infinidash auth key |
| <a name="output_name"></a> [name](#output\_name) | Infinidash dashboard name |
<!-- END_TF_DOCS -->

# CHANGELOG

v0.0.1
- Added this example README with fake resources