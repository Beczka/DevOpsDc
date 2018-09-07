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

variable "name" {
    type = "string"
}

variable sku {
 type = "string"
}

variable vault_id {
   type = "string"
}