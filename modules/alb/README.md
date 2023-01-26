# AWS ELB, S3 for VPC flow logs
Features
- ALB allow CF prefix list
- ALB allow all if CF is not in front

Dependencies
- VPC
- ACM

Deploying AWS ELB, enabled encrypted S3 bucket to store VPC flow logs

## Usage 
```
module "alb" {
  source                      = "github.com/CloudNation-nl/aws-terraform-modules/modules/alb/v0.0.1"
  name                        = "alb"
  load_balancer_internal      = "false"
  #   cloudfront                  = "true" 
  access_logs                 = "true"
  subnet_ids                  = [module.vpc.subnet_public_subnet_ids[0], module.vpc.subnet_public_subnet_ids[1]]
  vpc_id                      = module.vpc.vpc_id
  enable_deletion_protection  = "true"
  ssl_policy                  = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  default_certificate_arn     = module.acm.cert_arn
  additional_certificate_arns = []
  tags                        = local.tag (optional or point to tagging factory)
}
```