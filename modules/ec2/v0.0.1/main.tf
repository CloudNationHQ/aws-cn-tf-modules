locals {
  userdata = templatefile("../../modules/ec2/userdata.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}
resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config/${var.name}"
  type        = "String"
  value       = file("../../modules/ec2/cw_agent_config.json")
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 4.2.1"
  name                        = var.name
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id
  user_data                   = local.userdata
  vpc_security_group_ids      = [aws_security_group.management-security-group.id, aws_security_group.internal-security-group.id, aws_security_group.public-security-group.id]
  key_name                    = var.key_name
  monitoring                  = true
  enable_volume_tags          = false
  iam_instance_profile        = aws_iam_instance_profile.this.name
  root_block_device = [{
    volume_type = var.volume_type,
    volume_size = var.volume_size,
    encrypted   = true,
    kms_key_id  = aws_kms_key.this.arn
  tags = var.tags }]
  tags                    = var.tags
  private_ip              = var.private_ip
  disable_api_termination = true
  metadata_options = {
    http_tokens = "required"
  }
}

# Static Security group. Must exist since managing an instance is a bare necessity
resource "aws_security_group" "management-security-group" {
  name   = join("-", [var.name, "management-security-group"])
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.management_ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = [ingress.value["cidr_block"]]
      description = ingress.value["description"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Optional security group for public access.
resource "aws_security_group" "public-security-group" {
  name        = join("-", [var.name, "public-security-group"])
  description = join(" ", ["Public security group for", var.name])
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.public_ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = [ingress.value["cidr_block"]]
      description = ingress.value["description"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Optional security group for internal access.
resource "aws_security_group" "internal-security-group" {
  name   = join("-", [var.name, "internal-security-group"])
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.internal_ingress_rules
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

#Data Volume
resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2_instance.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.data_volume_size
  encrypted         = true
  type              = var.volume_type
  kms_key_id        = aws_kms_key.this.arn
  tags              = var.tags
}

resource "aws_ebs_volume" "extra_disc" {
  for_each          = var.extra_disk_config
  availability_zone = var.availability_zone
  size              = each.value.volume_size
  type              = each.value.volume_type
  kms_key_id        = aws_kms_key.this.arn
  encrypted         = true
  tags              = var.tags
}

resource "aws_volume_attachment" "extra_disc" {
  for_each    = var.extra_disk_config
  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.extra_disc[each.key].id
  instance_id = module.ec2_instance.id
}

resource "aws_kms_key" "this" {
  enable_key_rotation = true
}

# Alarms
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = join("-", [var.name, "cpu-utilization"])
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_alert_arn]
  dimensions                = { InstanceId = module.ec2_instance.id }
}

resource "aws_cloudwatch_metric_alarm" "ec2_memory" {
  alarm_name                = join("-", [var.name, "memory-utilization"])
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "Memory Available MBytes"
  namespace                 = "CWAgent"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 memory utilization"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_alert_arn]
  dimensions                = { InstanceId = module.ec2_instance.id }
}

resource "aws_cloudwatch_metric_alarm" "ec2_root_disk" {
  alarm_name                = join("-", [var.name, "root-disk-utilization"])
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "LogicalDisk Free Megabytes"
  namespace                 = "CWAgent"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 root disk utilization"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_alert_arn]
  dimensions                = { InstanceId = module.ec2_instance.id }
}
