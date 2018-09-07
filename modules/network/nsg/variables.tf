variable "name" {
    type = "string"
}

variable "region" {
    type = "string"
}

variable "tags" {
    type = "map"
}

variable "resource_group_name" {
    type = "string"
}

variable "rules" {
    type    = "list"
    default = []
}