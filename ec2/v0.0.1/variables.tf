variable "aws_region" {
  description = "The AWS region to create things in."
}
variable "name" {
  description = "The name of the instance."
  default     = "Instance"
  type        = string

}
variable "ami" {
  type    = string
  default = ""
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "key_name" {
  type    = string
  default = ""
}
variable "volume_type" {
  type    = string
  default = "gp3"
}
variable "volume_size" {
  type    = string
  default = "20"
}
variable "data_volume_size" {
  type    = string
  default = "50"
}

variable "extra_disk_config" {
  type = map(object({
    device_name = string
    volume_type = string
    volume_size = number
  }))
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
  description = "subnet id"
  type        = string
  default     = ""
}
variable "public_ports" {
  description = "Port numbers to be used in the security group"
  type        = list(number)
  default     = []
}

variable "vpc_id" {
  description = "vpc id"
}
variable "tags" {
  type = map(string)
}

variable "private_ip" {
  type        = string
  default     = null
  description = "Private IP address to associate with the instance in a VPC"
}
variable "private_hosted_zone_id" {
  type    = string
  default = ""
}

variable "associate_public_ip_address" {
  type    = string
  default = null
}

variable "public_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
}

variable "management_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
}
variable "internal_ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
    description     = string
  }))
}
variable "sns_alert_arn" {
  type = string
}