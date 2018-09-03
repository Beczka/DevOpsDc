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

variable "server_name" {
    type = "string"
}

variable "databases" {
  type = "list"
}