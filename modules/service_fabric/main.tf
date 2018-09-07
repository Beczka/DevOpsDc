resource "azurerm_template_deployment" "azure-backup-vault-item" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"

  template_body = "${file("${path.module}/templates/service-fabric.json")}"

  parameters {
    "tagValues"                           = "${jsonencode(var.tags)}"
    "clusterLocation" = ""
    "clusterName" = ""
    "subnet0Name" = "Subnet-0"
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""
    "clusterLocation" = ""

  }

  deployment_mode = "Incremental"
}