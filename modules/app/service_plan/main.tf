resource "azurerm_app_service_plan" "service_plan" {
 count =  "${length(var.plans)}"
  name                = "${lookup(var.plans[count.index], "name")}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
   tags                = "${var.tags}"

  sku {
    tier = "${lookup(var.plans[count.index], "tier")}" 
    size = "${lookup(var.plans[count.index], "size")}"
  }
}