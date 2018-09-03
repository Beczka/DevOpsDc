variable "region" {
  type = "string"
}

variable "plans" {
   type = "list"
}

variable "resource_group_name" {
    type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}