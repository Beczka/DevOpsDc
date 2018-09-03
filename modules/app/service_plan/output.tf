output "plans_ids" {
  value = "${azurerm_app_service_plan.service_plan.*.id}"
}
