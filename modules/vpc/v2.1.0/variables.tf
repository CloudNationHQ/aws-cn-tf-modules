variable "private_zone_name" {
  description = "private zone name."
  default     = "example.lan"
  type        = string
}

variable "env" {
  description = "environment name."
  default     = "dev"
  type        = string
}

variable "cidr_range" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  type        = map(any)
  description = "A list of public subnet tags"

  default = {
    Network                  = "Public",
    "kubernetes.io/role/elb" = "1"
  }
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "A list of private subnet tags"

  default = {
    Network                           = "Private",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

variable "database_subnet_group_name" {
  default     = ""
  description = "Use this to prevent renaming a database subnet when renaming VPC"
  type        = string
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnet_tags" {
  type        = map(any)
  description = "A list of database subnet tags"

  default = {
    Network = "Database"
  }
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
}

variable "enable_flow_log" {
  type        = bool
  description = "Boolean to disable/enable VPC flow logging"
  default     = false
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "tags"
}

variable "flow_log_retention_days" {
  type        = number
  description = "VPC flow log bucket lifecycle retention period in days"
  default     = 30
}
variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "create_database_nat_gateway_route" {
  default     = false
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
  type        = bool
}

variable "enable_ipv6" {
  default     = false
  type        = bool
  description = "Enables IPv6"
}

variable "public_subnet_ipv6_prefixes" {
  default     = []
  type        = list(any)
  description = "List of public subnet ipv6 prefixes"
}