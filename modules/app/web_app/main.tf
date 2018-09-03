resource "azurerm_app_service" "web-app" {
  count =               "${var.count}"
  name                = "${lookup(var.apps[count.index], "name")}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  app_service_plan_id = "${lookup(var.apps[count.index], "app_service_plan_id")}"
  tags                = "${var.tags}"
}