variable "name" {
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

variable "vault_url" {
   type = "string"
}

variable "administrator_login" {
   type = "string"
}

variable "firewall_rules" {
  type    = "list"
}

variable "subnet_ids" {
  type = "list"
  default = []
}

variable "networks_count" {
  default = "1"
}
