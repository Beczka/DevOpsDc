variable "vault_url" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "resource_group_name" {
  type = "string"
}

variable "virtual_machine_name" {
  type = "string"
}

variable "dsc_configuration_name" {
  type = "string"
}

variable name {
  type    = "string"
}

variable count {
   type    = "string"
}