module "nsg" {
  source              = "../nsg"
  resource_group_name = "${var.resource_group_name}"
  region              = "${var.region}"
  tags                = "${var.tags}"
  name                = "${var.name}"
  rules               = "${var.nsg_rules}"
}

resource "azurerm_subnet" "subnet" {
  name                      = "${var.name}"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.virtual_network_name}"
  address_prefix            = "${var.address_prefix}"
  network_security_group_id = "${module.nsg.nsg_id}"
  service_endpoints         = "${var.service_endpoints}"
  route_table_id            = "${var.route_table_id}"

  lifecycle {
    create_before_destroy = true
  }
}
