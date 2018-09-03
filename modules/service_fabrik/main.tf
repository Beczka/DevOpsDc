resource "azurerm_service_fabric_cluster" "service_fabric" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  reliability_level   = "Bronze"
  upgrade_mode        = "Automatic"
  vm_image            = "Windows"
  management_endpoint = "https://example:80"
 add_on_features {

    }
  node_type {
    name                 = "fronend"
    instance_count       = 1
    is_primary           = true
    client_endpoint_port = 2020
    http_endpoint_port   = 80
  }
  node_type {
    name                 = "backend"
    instance_count       = 1
    is_primary           = true
    client_endpoint_port = 2020
    http_endpoint_port   = 80
  }
}