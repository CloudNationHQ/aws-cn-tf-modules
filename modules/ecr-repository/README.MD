ECR Repository

# Features

- ECR repository
- KMS Encryption optional
- Share pull permissions with AWS Principals
- Input lifecycle policy as IAM

# Usage

```
module "ecr" {
  source         = "github.com/CloudNation-nl/aws-terraform-modules//modules/ecr-repository/v0.0.1"
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_iam_policy_document.this_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | List of AWS account IDs or ARNs that are allowed to pull images | `any` | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | When enabled, you can delete the repository when there are images inside. | `bool` | `false` | no |
| <a name="input_kms_encryption"></a> [kms\_encryption](#input\_kms\_encryption) | Enables KMS encryption for the repo. Default is AES256 | `bool` | `false` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | Lifecycle policy IAM document | `any` | `null` | no |
| <a name="input_mutability"></a> [mutability](#input\_mutability) | MUTABLE or IMMUTABLE | `string` | `"MUTABLE"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the ECR Repo | `string` | `"my-ecr-repo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags that are added to the repository (and KMS keys) | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | n/a |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | n/a |

# CHANGELOG

v0.0.1
- First version of ECR Repository module