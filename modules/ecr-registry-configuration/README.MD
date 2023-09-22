ECR Registry Configuration. 

# Features

- Configure image scanning settings.

# Usage

```
module "ecr-registry-config" {
  source         = "github.com/CloudNationHQ/aws-cn-tf-modules//modules/ecr-registry-configuration/v0.0.1"
}
```

# Troubleshooting

An error like this can occur when importing the resource :

```
When applying changes to module.xxx.module.ecr-registry-config.aws_ecr_registry_scanning_configuration.this[0], provider "provider[\"registry.terraform.io/hashicorp/aws\"]" produced an unexpected new value: Root resource was present, but now absent.
```

This can be solved by importing the resource with the correct registry id.
get the registry id with (this might always be the same as the AWS account id):

```
aws ecr get-registry-scanning-configuration --no-cli-pager --output text --query "registryId"
```

import the resource with : 

```
terraform import "module.xxx.module.ecr-registry-config.aws_ecr_registry_scanning_configuration.this[0]" <registry_id_retrieved_with_previous_command>
```

Terraform apply should now work without errors.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_continuous_scan_filter"></a> [continuous\_scan\_filter](#input\_continuous\_scan\_filter) | List of glob patterns to match against the image name. If the image name matches any of the patterns, the image will be scanned continuously. Default is wildcard | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_enable_registry_scanning"></a> [enable\_registry\_scanning](#input\_enable\_registry\_scanning) | Enable registry scanning | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

# CHANGELOG

v0.0.1
- Added this example README with fake resources