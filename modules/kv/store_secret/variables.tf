variable "name" {
  type = "string"
}

variable "value_to_store" {
   type = "string"
}

variable "vault_uri" {
  type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}
