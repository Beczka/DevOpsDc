resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "${var.name}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.sku}"
 tags                = "${var.tags}"
}

module "servicebus_primary_cs" {
  source    = "../kv/store_secret"
  vault_uri = "${var.vault_url}"
  secrets = [{
    name      = "servicebus-primary-cs"
    value_to_store = "${azurerm_servicebus_namespace.servicebus.default_primary_connection_string }"
  }]
}

module "servicebus_secondary_cs" {
  source    = "../kv/store_secret"
  vault_uri = "${var.vault_url}"
  secrets = [{
    name      = "servicebus-secondary-cs"
    value_to_store = "${azurerm_servicebus_namespace.servicebus.default_secondary_connection_string }"
  }]
}