
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v3.19.0"
  name    = join("-", [var.env, data.aws_region.current.name, "vpc"])
  cidr    = var.cidr_range

  azs                                = length(var.azs) > 0 ? var.azs : ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  public_subnets                     = length(var.public_subnets) > 0 ? var.public_subnets : [cidrsubnet(var.cidr_range, 8, 0), cidrsubnet(var.cidr_range, 8, 1), cidrsubnet(var.cidr_range, 8, 2)]
  public_subnet_tags                 = var.public_subnet_tags
  public_route_table_tags            = var.public_subnet_tags
  private_subnets                    = length(var.private_subnets) > 0 ? var.private_subnets : [cidrsubnet(var.cidr_range, 8, 3), cidrsubnet(var.cidr_range, 8, 4), cidrsubnet(var.cidr_range, 8, 5)]
  private_subnet_tags                = var.private_subnet_tags
  private_route_table_tags           = var.private_subnet_tags
  database_subnets                   = length(var.database_subnets) > 0 ? var.database_subnets : [cidrsubnet(var.cidr_range, 8, 6), cidrsubnet(var.cidr_range, 8, 7), cidrsubnet(var.cidr_range, 8, 8)]
  database_subnet_tags               = var.database_subnet_tags
  database_route_table_tags          = var.database_subnet_tags
  create_database_subnet_route_table = true
  database_subnet_group_name         = var.database_subnet_group_name
  create_database_nat_gateway_route  = var.create_database_nat_gateway_route

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_flow_log           = var.enable_flow_log
  flow_log_destination_arn  = var.enable_flow_log ? aws_s3_bucket.vpc_log[0].arn : null
  flow_log_destination_type = var.enable_flow_log ? "s3" : null
  flow_log_traffic_type     = var.enable_flow_log ? "REJECT" : null

  map_public_ip_on_launch         = false
  enable_dns_hostnames            = true
  manage_default_security_group   = true
  create_elasticache_subnet_group = true

  tags = var.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> v3.19.0"
  vpc_id  = module.vpc.vpc_id
  endpoints = {
    s3 = {
      service         = "s3"
      tags            = { Name = "s3-vpc-endpoint" }
      route_table_ids = flatten([module.vpc.database_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      service_type    = "Gateway"
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.database_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "dynamodb-vpc-endpoint" }
    },
  }

  tags = var.tags
}

resource "aws_s3_bucket" "vpc_log" {
  count  = var.enable_flow_log ? 1 : 0
  bucket = join("-", [module.vpc.vpc_id, "vpc-flowlog"])
  tags   = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.enable_flow_log ? 1 : 0
  bucket = aws_s3_bucket.vpc_log[0].id
  rule {
    status = "Enabled"
    expiration {
      days = var.flow_log_retention_days
    }
    id = "expire-${var.flow_log_retention_days}-days"
  }
}

resource "aws_s3_bucket_public_access_block" "vpc_log" {
  count                   = var.enable_flow_log ? 1 : 0
  bucket                  = aws_s3_bucket.vpc_log[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_s3_bucket_policy" "vpc-bucket-policy" {
  count  = var.enable_flow_log ? 1 : 0
  bucket = aws_s3_bucket.vpc_log[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.vpc_log[0].arn}/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.vpc_log[0].arn}",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
                }
            }
        },
    {
        "Sid": "EnforceTls",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
            "${aws_s3_bucket.vpc_log[0].arn}/*",
            "${aws_s3_bucket.vpc_log[0].arn}"
        ],
        "Condition": {
            "Bool": {
                "aws:SecureTransport": "false"
            }
        }
    }            
    ]
}
POLICY
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  count  = var.enable_flow_log ? 1 : 0
  bucket = aws_s3_bucket.vpc_log[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_vpc[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "kms_vpc" {
  count               = var.enable_flow_log ? 1 : 0
  enable_key_rotation = true
  tags                = var.tags
  policy              = <<POLICY
  {
      "Version": "2012-10-17",
      "Id": "vpc-flow-log-key",
      "Statement": [
          {
              "Sid": "Enable IAM User Permissions",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
              },
              "Action": "kms:*",
              "Resource": "*"
          },
          {
              "Sid": "Allow VPC Flow Logs to use the key",
              "Effect": "Allow",
              "Principal": {
                  "Service": [
                      "delivery.logs.amazonaws.com"
                  ]
              },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
              ],
              "Resource": "*"
          }          
      ]
  }
    POLICY
}

data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["dynamodb:*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpc"

      values = [module.vpc.vpc_id]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_route53_zone" "private" {
  vpc {
    vpc_id = module.vpc.vpc_id
  }

  name = var.private_zone_name
  lifecycle {
    ignore_changes = [vpc]
  }
}