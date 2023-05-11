resource "aws_kms_key" "efs" {
  tags                = var.tags
  enable_key_rotation = true
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow direct access to key metadata to the account",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : [
          "kms:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_efs_file_system" "efs" {
  encrypted      = true
  kms_key_id     = aws_kms_key.efs.arn
  tags           = var.tags
  creation_token = var.name
  lifecycle_policy {
    transition_to_ia = lookup(var.lifecycle_policies, "transition_to_ia", null)
  }

  lifecycle_policy {
    transition_to_primary_storage_class = lookup(var.lifecycle_policies, "transition_to_primary_storage_class", null)
  }
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
}

resource "aws_efs_mount_target" "mount_target_a" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[0]
  security_groups = [aws_security_group.security-group.id]
}

resource "aws_efs_mount_target" "mount_target_b" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[1]
  security_groups = [aws_security_group.security-group.id]
}

resource "aws_efs_mount_target" "mount_target_c" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[2]
  security_groups = [aws_security_group.security-group.id]
}

resource "aws_security_group" "security-group" {
  name   = join("-", [var.name, "efs-security-group"])
  tags   = var.tags
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_security_groups
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      security_groups = ingress.value["security_groups"]
      description     = ingress.value["description"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}