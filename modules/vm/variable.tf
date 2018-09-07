variable "region" {
  type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "subnet_id" {
  type = "string"
}

variable "vault_url" {
  type = "string"
}

variable "count" {
  type = "string"
}

variable name {
 type = "string"
}

variable resource_group_name {
   type = "string"
}
