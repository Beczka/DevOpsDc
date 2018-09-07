resource "azurerm_automation_account" "vm-automation" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"

  sku {
    name = "${var.sku}"
  }

  tags = "${var.tags}"
}

module "resource-data" {
  source  = "../general/resource_id_data"
  resource_id = "${azurerm_automation_account.vm-automation.id}"
}

module "resource-data-kv" {
  source  = "../general/resource_id_data"
  resource_id = "${var.vault_id}"
}

data "azurerm_client_config" "current" {}

resource "null_resource" "powershell-workaround" {
  provisioner "local-exec" {
    working_dir = "${path.module}"
    interpreter = ["powershell", "-ExecutionPolicy", "Bypass"]
    command     = ".\\UploadConnectionDetails.ps1 -subscription_id ${data.azurerm_client_config.current.subscription_id} -client_id ${data.azurerm_client_config.current.client_id} -tenant_id ${data.azurerm_client_config.current.tenant_id} -vault_name ${module.resource-data-kv.resource_id_map["vaults"]} -resource_group ${var.resource_group_name} -automation_account_name ${module.resource-data.resource_id_map["automationAccounts"]}"
  }
   depends_on = ["azurerm_automation_account.vm-automation"]
}