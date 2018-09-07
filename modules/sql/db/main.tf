resource "azurerm_sql_database" "db" {
  count               = "${var.count}"
  name                = "${lookup(var.databases[count.index], "name")}"
  edition             = "${lookup(var.databases[count.index], "edition")}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  server_name         = "${var.server_name}"
 
  tags                = "${var.tags}"
}

module "azurerm_sql_database_connection_strings" {
  source              = "../../../modules/kv/store_secret"
  count = "${var.count}"
  vault_uri = "${var.vault_url}"
  secrets = "${var.databases}"
}