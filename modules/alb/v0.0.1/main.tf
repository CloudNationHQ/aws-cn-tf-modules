#Create an application load balancer. Can be either public or internal.
resource "aws_lb" "loadbalancer" {
  name                       = var.name
  internal                   = var.load_balancer_internal
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_lb.id]
  subnets                    = var.subnet_ids
  drop_invalid_header_fields = true

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = 3600
  access_logs {
    count   = var.enable_access_logs ? 1 : 0
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "${var.name}-lb_logs"
    enabled = true
  }

  tags = var.tags
}

#Create a HTTP listener that redirects all traffic to HTTPS
resource "aws_lb_listener" "http" {
  count             = var.use_cloudfront ? 0 : 1
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#Create a HTTPS listener that has a default response of 503
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.default_certificate_arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

#Attach any additional certificates to the HTTPS listener
resource "aws_lb_listener_certificate" "certificate" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}

#Create the public security group
data "aws_ec2_managed_prefix_list" "cloudfront" {
  count = var.use_cloudfront ? 1 : 0
  name  = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "allow-lb-cf" {
  count       = var.use_cloudfront ? 1 : 0
  name        = "${var.name}-sg-cf"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "443 from cloudfront"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }
}

resource "aws_security_group" "allow-lb" {
  count       = var.use_cloudfront ? 0 : 1
  name        = "${var.name}-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  ingress {
    description = "443 from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }
}

resource "aws_s3_bucket" "lb_logs" {
  count         = var.enable_access_logs ? 1 : 0
  bucket_prefix = join("-", [var.name, "lb-logs"])
  tags          = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.enable_access_logs ? 1 : 0
  bucket = aws_s3_bucket.lb_logs.id
  rule {
    id = "expire-30"
    expiration {
      days = 30
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  count                   = var.enable_access_logs ? 1 : 0
  bucket                  = aws_s3_bucket.lb_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  count  = var.enable_access_logs ? 1 : 0
  bucket = aws_s3_bucket.lb_logs.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "lb-bucket-policy" {
  count  = var.enable_access_logs ? 1 : 0
  bucket = aws_s3_bucket.lb_logs.id

  policy = <<POLICY
{
  "Id": "alblogpolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "allowalbeucentral",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.lb_logs.arn}/*",
      "Principal": {
        "AWS": [
           "arn:aws:iam::054676820928:root"
        ]
      }
    },
    {
        "Sid": "EnforceTls",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
            "${aws_s3_bucket.lb_logs.arn}/*",
            "${aws_s3_bucket.lb_logs.arn}"
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