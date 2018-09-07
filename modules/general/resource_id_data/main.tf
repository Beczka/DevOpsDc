locals {
  resource_id_split = "${split("/", var.resource_id)}"
}
