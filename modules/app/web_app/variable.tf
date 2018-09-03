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

variable "apps" {
   type = "list"
}

variable "count" {
    type = "string"
    default = "1"
}
