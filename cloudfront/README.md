# CloudFront 

Features 
- Automatically create an A Record with Alias for CloudFront distribution
- Insert multiple domain names to reroute CloudFormation
- IP Whitelisting on CloudFront, perfect for staging or acceptance environment

Dependencies
- ALB
- ACM
- WAF if you want to use IP sets

## Usage

```
module "cf" {
  source       = "github.com/CloudNation-nl/aws-terraform-modules//cloudfront/v0.0.1"
  alb_dns_name = module.alb.dns_name
  # wafv2_arn    = module.wafv2cf.wafv2cf_arn (enable this for using IP set as whitelist method)
  zone_id = module.route53.public_zone_id
  description  = "<insert description>"
  domain_names = [
    "<insert url>",
    "*.<insert url>"
  ]
  certificate_arn = module.acm.cert_arn_cloudfront
  tags            = local.tags (or use tags-factory)
}
```