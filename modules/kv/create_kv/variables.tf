variable "name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "resource_group_name" {
    type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "operation_ad_group" {
  type = "string"
  default = ""
}


