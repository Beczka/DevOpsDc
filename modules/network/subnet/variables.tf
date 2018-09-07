variable "name" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "nsg_rules" {
  type    = "list"
  default = []
}

variable "address_prefix" {
  type = "string"
}

variable "service_endpoints" {
  type    = "list"
  default = []
}

variable "route_table_id" {
  type    = "string"
  default = ""
}

variable "region" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "virtual_network_name" {
  default = "string"
}
