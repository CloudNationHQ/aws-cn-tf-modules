CloudFront with dependencies such as WAF and ALB
Deploy this module inconjuction with the loadbalancer

- Fill in the description 
- Fill in the domain names that needs to be attached to CloudFront

# Usage

```
module "cf" {
  source       = "../../modules/cloudfront"
  alb_dns_name = module.alb.dns_name
  wafv2_arn    = module.wafv2cf.wafv2cf_arn
  description  = ""
  domain_names = [
    ""
  ]
  certificate_arn = module.acm.cert_arn_cloudfront
  tags            = module.tags-factory.tags
}
```