resource "aws_route53_zone" "public" {
  name          = var.public_zone_name
  comment       = "${var.public_zone_name} public zone"
  tags          = var.tags
  force_destroy = var.force_destroy
}

resource "aws_route53_record" "publiczone-caa" {
  count   = length(var.CAA) != 0 ? 1 : 0
  zone_id = aws_route53_zone.public.zone_id
  name    = aws_route53_zone.public.name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}

#DNSSEC
resource "aws_kms_key" "this" {
  count                    = var.dnssec == true ? 1 : 0
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:route53:::hostedzone/*"
          }
        }
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_route53_key_signing_key" "this" {
  count                      = var.dnssec == true ? 1 : 0
  hosted_zone_id             = aws_route53_zone.public.zone_id
  key_management_service_arn = aws_kms_key.this[0].arn
  name                       = "dnssec"
}

resource "aws_route53_hosted_zone_dnssec" "this" {
  count = var.dnssec == true ? 1 : 0
  depends_on = [
    aws_route53_key_signing_key.this[0]
  ]
  hosted_zone_id = aws_route53_key_signing_key.this[0].hosted_zone_id
}