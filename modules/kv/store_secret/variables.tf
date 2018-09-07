variable "vault_uri" {
  type = "string"
}

variable "secrets" {
  type    = "list"
}

variable "count" {
  type ="string"
  default = "1"
}