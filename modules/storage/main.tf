resource "azurerm_storage_account" "storage-account" {
  name                     = "${var.name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = "${var.tags}"
}

resource "azurerm_storage_table" "storage-table" {
  name                 = "${var.storage_table_name}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"
}

module "storage_primary_cs" {
  source    = "../kv/store_secret"
  vault_uri = "${var.vault_url}"
  secrets = [{
    name      = "storage-primary-cs"
    value_to_store = "${azurerm_storage_account.storage-account.primary_connection_string }"
  }]
}

module "storage_secondary_cs" {
  source    = "../kv/store_secret"
  vault_uri = "${var.vault_url}"
  secrets = [{
    name      = "storage-secondary-cs"
    value_to_store = "${azurerm_storage_account.storage-account.secondary_connection_string }"
  }]
}