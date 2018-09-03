resource "azurerm_application_insights" "app-insights" {
  name                = "${var.name}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  application_type    = "Web"
}

module "app_insights_instrumentation_key" {
  source    = "../kv/store_secret"
  name      = "app-insights-instrumentation-key"
  vault_uri = "${var.vault_url}"
  value_to_store = "${azurerm_application_insights.app-insights.instrumentation_key}"
  tags = "${var.tags}"
}