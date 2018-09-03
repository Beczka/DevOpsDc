resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "${var.name}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.sku}"
 tags                = "${var.tags}"
}

module "servicebus_primary_cs" {
  source    = "../kv/store_secret"
  name      = "servicebus-primary-cs"
  vault_uri = "${var.vault_url}"
  value_to_store = "${azurerm_servicebus_namespace.servicebus.default_primary_connection_string }"
  tags = "${var.tags}"
}

module "servicebus_secondary_cs" {
  source    = "../kv/store_secret"
  name      = "servicebus-secondary-cs"
  vault_uri = "${var.vault_url}"
  value_to_store = "${azurerm_servicebus_namespace.servicebus.default_secondary_connection_string }"
  tags = "${var.tags}"
}