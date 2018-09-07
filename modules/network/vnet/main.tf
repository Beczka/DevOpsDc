
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  address_space       = ["${var.address_space}"]
  tags                = "${var.tags}"
}
