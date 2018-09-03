resource "azurerm_sql_database" "db" {
  count               ="${length(var.databases)}"
  name                = "${lookup(var.databases[count.index], "name")}"
  edition             = "${lookup(var.databases[count.index], "edition")}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  server_name         = "${var.server_name}"
  tags                = "${var.tags}"
}