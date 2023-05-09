
variable "name" {
  description = "Name."
  type        = string
}
variable "private_zone_name" {
  type        = string
  description = "private zone name."
}
variable "env" {
  description = "environment name."
  type        = string
}
variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}
variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(any)
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
}
variable "public_subnet_tags" {
  type        = map(any)
  description = "A list of public subnet tags"

  default = {
    Network = "Public"
  }
}
variable "private_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
}
variable "private_subnet_tags" {
  type        = map(any)
  description = "A list of private subnet tags"

  default = {
    Network = "Private"
  }
}
variable "database_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
}
variable "database_subnet_tags" {
  type        = map(any)
  description = "A list of database subnet tags"

  default = {
    Network = "Database"
  }
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
  type        = bool
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
  type        = bool
}
variable "tags" {
  type        = map(any)
  description = "Map of tags"
}
variable "deletion_window_in_days" {
  type        = number
  default     = 30
  description = "How many days to keep VPC flow logs"
}
