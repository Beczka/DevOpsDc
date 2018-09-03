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

variable "firewall_start_ip_address" {
   type = "string"
}

variable "firewall_end_ip_address" {
   type = "string"
}
