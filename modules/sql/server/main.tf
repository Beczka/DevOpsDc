module "sql-serwer" {
  source              = "../../../modules/kv/create_and_store_secret"
  name                = "${var.name}-admin-password"
  vault_uri           = "${var.vault_url}"
  tags                = "${var.tags}"
}

resource "azurerm_sql_server" "sql-serwer" {
    name                = "${var.name}"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.region}"
    version             = "12.0"
    administrator_login = "${var.administrator_login}"
    administrator_login_password = "${module.sql-serwer.password}"
}

resource "azurerm_sql_virtual_network_rule" "db-subnet" {
  count               = "${var.networks_count}"
  name                = "${var.name}-db-${var.region}-subnet-${element(split("/",var.subnet_ids[count.index]), length(split("/",var.subnet_ids[count.index])) - 1)}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.sql-serwer.name}"
  subnet_id           = "${var.subnet_ids[count.index]}"
}

resource "azurerm_sql_firewall_rule" "rules" {
  count               = "${length(var.firewall_rules)}"
  name                = "${lookup(var.firewall_rules[count.index], "name")}"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.sql-serwer.name}"
  start_ip_address    = "${lookup(var.firewall_rules[count.index], "start_ip_address")}"
  end_ip_address      = "${lookup(var.firewall_rules[count.index], "end_ip_address")}"
}