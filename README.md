# aws-terraform-modules
Public modules for use with Terraform

# Usage

Call as a module from Terraform: 

```
module "s3" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//s3/v0.0.1"
  bucket = "mybucket"
}
```

Run `terraform init` and `terraform plan` and `terraform apply`

# Versioning

Modules once uploaded will never change. New versions can have minor fixes (vx.x.1->vx.x.2), added resources (vx.1.x->vx.2.x) or breaking changes (v1.x.x->2.x.x)

# License, Bugs, issues and questions

CloudNation offers these modules free of charge. If you're missing features, find a bug or need other support, please create an issue on Github.

# Adding modules

See `modules/_example` for an example that you can use as a start

Please open a Pull Request for any new versions, make sure to adhere to the versioning strategy and to update the README.md with the changes made. Pull requests are automatically verified using `terraform fmt`. To ensure these tests succeed, perform these against your changes first.

## Module names

Modules must be named locigally and allow for future addition of other features in the same namespace. E.g. don't name an S3 bucket just `bucket` or `s3` but `s3-bucket`.

Some module names can be obvious like `ecs-cluster` and `ecs-service`, but sometimes the module can be named for it's `purpose`, e.g. `sns-alarms` which is an SNS topic that you can use for CW alarms.

## KMS Alias names

KMS aliasses must be named logically and uniformly. Examples are:

- "alias/ecr/repository/${var.name}"
- "alias/ecs/cluster/${var.name}"
- "alias/sns/topic/${var.name}"

## DNS Records

DNS records for private hosted zones must adhere to the following pattern:

`{name}.{namespace}.{private_hosted_zone_name}`

Some examples:

- `webappdb.rds.company.local`
- `products.opensearch.company.local`
- `bastion.ec2.company.local`

## Useful commands

## Terraform docs
Run the following command from the module version root to automatically create or update terraform documentation:

```terraform-docs markdown --output-file ../README.md --output-mode inject .```

## Terraform code formatting

Run the following command from the project root (or module root) to format your code format nicely:

```terraform fmt -recursive```

This is a requirement for every pull request.

## Terraform code validation

Run the following command from the /modules folder to validate your terraform to best practices:

```tflint --init && tflint --recursive --config ".tflint.hcl"```

This is a requirement for every pull request.