locals {
  region_lower       = "${lower(var.region)}"
  last_rule_priority = 4000
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg-${local.region_lower}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  tags                = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_security_rule" "nsg-rule" {
  count                       = "${length(var.rules)}"
  name                        = "Allow_${lookup(var.rules[count.index], "name")}"
  priority                    = "${local.last_rule_priority - (length(var.rules) - count.index) * 100}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "${lookup(var.rules[count.index], "source")}"
  destination_port_range      = "${lookup(var.rules[count.index], "port")}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}
