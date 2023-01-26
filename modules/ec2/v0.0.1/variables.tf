variable "aws_region" {
  description = "The AWS region to create things in."
}
variable "name" {
  description = "The name of the instance."
  default     = "Instance"
  type        = string

}
variable "ami" {
  type        = string
  default     = ""
  description = "AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI."
}
variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Instance type to use for the instance. Required unless launch_template is specified and the Launch Template specifies an instance type. "
}
variable "key_name" {
  type        = string
  default     = ""
  description = "Key name of the Key Pair to use for the instance; which can be managed using the aws_key_pair resource"
}
variable "volume_type" {
  type        = string
  default     = "gp3"
  description = "Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1"
}
variable "volume_size" {
  type        = string
  default     = "20"
  description = "Size of the volume in gibibytes (GiB)."
}
variable "data_volume_size" {
  type        = string
  default     = "50"
  description = "Size of the volume in gibibytes (GiB)."
}

variable "extra_disk_config" {
  type = map(object({
    device_name = string
    volume_type = string
    volume_size = number
  }))
  description = "Size of the extra volumes in gibibytes (GiB)."
}

variable "EC2_ROOT_VOLUME_DELETE_ON_TERMINATION" {
  type    = string
  default = "false"
}

variable "availability_zone" {
  description = "availability zones in the region"
  type        = string
  default     = ""
}
variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type        = string
  default     = ""
}
variable "public_ports" {
  description = "Port numbers to be used in the security group"
  type        = list(number)
  default     = []
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID. Defaults to the region's default VPC."
}
variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
}

variable "private_ip" {
  type        = string
  default     = null
  description = "Private IP address to associate with the instance in a VPC"
}
variable "private_hosted_zone_id" {
  type        = string
  default     = ""
  description = "private hosted zone ID from VPC"
}

variable "associate_public_ip_address" {
  type        = string
  default     = null
  description = "Whether to associate a public IP address with an instance in a VPC."
}

variable "public_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  description = "Security rules for public security group"
}

variable "management_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  description = "Security rules for management security group"
}
variable "internal_ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
    description     = string
  }))
  description = "Security rules for internal security group"
}

variable "sns_alert_arn" {
  type        = string
  description = "When CloudWatch receives an error message, it will notifies the subscribers in the SNS group"
}