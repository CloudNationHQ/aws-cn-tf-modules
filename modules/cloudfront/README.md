# Features 

- Automatically create an A Record with Alias for CloudFront distribution
- Configurable domain names to reroute within CloudFront
- Configurable IP Whitelisting (perfect for staging or acceptance environment)
- Configurable restriction_type 
- Configurable locations
- Configurable ssl_support_method
- Configurable minimum_protocol_version

# Usage

```
module "vpc" {
  source                  = "github.com/CloudNation-nl/aws-terraform-modules/modules/cloudfront/v0.0.1"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cf_dist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.public_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_dns_name"></a> [alb\_dns\_name](#input\_alb\_dns\_name) | The DNS domain name in ALB. | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Any comments you want to include about the distribution. | `string` | n/a | yes |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | n/a | yes |
| <a name="input_locations"></a> [locations](#input\_locations) | The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). | `list` | `[]` | no |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1.2_2018"` | no |
| <a name="input_restriction_type"></a> [restriction\_type](#input\_restriction\_type) | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. | `string` | `"none"` | no |
| <a name="input_ssl_support_method"></a> [ssl\_support\_method](#input\_ssl\_support\_method) | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. | `string` | `"sni-only"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags assigned to the resource | `map(any)` | n/a | yes |
| <a name="input_wafv2_arn"></a> [wafv2\_arn](#input\_wafv2\_arn) | A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws\_wafv2\_web\_acl.example.arn. | `string` | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The ID of the hosted zone to contain this record. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_arn"></a> [cloudfront\_arn](#output\_cloudfront\_arn) | arn of cloudfront |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The domain name corresponding to the distribution |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID |
