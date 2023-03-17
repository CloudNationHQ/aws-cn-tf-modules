Public Route53 Zone

# Features

- Creates a Route53 Public hosted zone based on the input name
- Creates CAA record for the Amazon.com CA

# Usage

```
module "example" {
  source            = "github.com/CloudNation-nl/aws-terraform-modules//modules/route53-publiczone/v0.0.1"
  public_zone_name  = "example.com"
}
```

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.publiczone-caa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_zone_name"></a> [public\_zone\_name](#input\_public\_zone\_name) | Name for the public zone, e.g. example.com | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_name_servers"></a> [public\_name\_servers](#output\_public\_name\_servers) | n/a |
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | n/a |

# CHANGELOG

v0.0.1
- Initial version