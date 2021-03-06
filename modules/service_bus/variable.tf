
variable "name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "sku" {
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
