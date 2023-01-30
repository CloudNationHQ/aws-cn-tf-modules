variable "name" {
  type = string
  description = "The fully qualified name for the directory, such as corp.example.comThe fully qualified name for the directory, such as corp.example.com"
}

variable "type" {
  type = string
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD."
}

variable "edition" {
  type = string
  description = " (Optional, for type MicrosoftAD only) The MicrosoftAD edition (Standard or Enterprise). Defaults to Enterprise."
}

variable "vpc_id" {
  type = string
  description = "The identifier of the VPC that the directory is in."
}

variable "subnet_ids" {
  type = list(string)
  description = "The identifiers of the subnets for the directory servers (2 subnets in 2 different AZs)."
}

variable "tags" {
  type = map(any)
  description = " A map of tags to assign to the resource."
}

variable "key" {
  type = string
  default = "tag:adjoin"
  description = "The tag to apply an SSM document to."
}

variable "values" {
  type = list(string)
  description = "The tag to apply an SSM document to."
  default = ["true"]
}