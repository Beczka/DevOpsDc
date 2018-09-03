module "sql-serwer" {
  source              = "../../../modules/kv/create_and_store_secret"
  name                = "${var.name}-admin-password"
  vault_uri           = "${var.vault_url}"
  tags                = "${var.tags}"
}

resource "azurerm_sql_server" "sql-serwer" {
    name = "${var.name}"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.region}"
    version = "12.0"
    administrator_login = "${var.administrator_login}"
    administrator_login_password = "${module.sql-serwer.password}"
}

resource "azurerm_sql_firewall_rule" "all" {
  name                = "All"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.sql-serwer.name}"
  start_ip_address    = "${var.firewall_start_ip_address}"
  end_ip_address      = "${var.firewall_end_ip_address}"
}