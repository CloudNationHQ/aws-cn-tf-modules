module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v3.14.0"
  name    = join("-", [var.name, var.env, "vpc"])
  cidr    = var.cidr

  azs                       = var.azs
  public_subnets            = var.public_subnets
  public_subnet_tags        = var.public_subnet_tags
  public_route_table_tags   = var.public_subnet_tags
  private_subnets           = var.private_subnets
  private_subnet_tags       = var.private_subnet_tags
  private_route_table_tags  = var.private_subnet_tags
  database_subnets          = var.database_subnets
  database_subnet_tags      = var.database_subnet_tags
  database_route_table_tags = var.database_subnet_tags

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  map_public_ip_on_launch         = false
  enable_dns_hostnames            = true
  manage_default_security_group   = true
  create_elasticache_subnet_group = true

  tags = var.tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
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

# Private zone
resource "aws_route53_zone" "private" {
  vpc {
    vpc_id = module.vpc.vpc_id
  }

  name = var.private_zone_name
  lifecycle {
    ignore_changes = [vpc]
  }
}

### VPC FLOW LOG
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_s3_bucket.vpc_log.arn
  log_destination_type = "s3"     #var.log_destination_type
  traffic_type         = "REJECT" #var.traffic_type
  vpc_id               = module.vpc.vpc_id
}

resource "aws_s3_bucket" "vpc_log" {
  bucket = join("-", [module.vpc.vpc_id, "vpc-flowlog"])
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "vpc_log" {
  bucket = aws_s3_bucket.vpc_log.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.vpc_log.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_vpc_flow_log.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "kms_vpc_flow_log" {
  deletion_window_in_days = var.deletion_window_in_days
  tags                    = var.tags
}
### END VPC FLOW LOG

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
      variable = "aws:sourceVpce"

      values = [module.vpc.vpc_id]
    }
  }
}