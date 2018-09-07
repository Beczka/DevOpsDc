module "dsc-endpoint" {
  source    = "../../../kv/get_secret"
  vault_uri = "${var.vault_url}"
  name = "automation-account-endpoint"
}

module "dsc-key" {
  source    = "../../../kv/get_secret"
  vault_uri = "${var.vault_url}"
  name = "automation-account-primary-key"
}

resource "azurerm_virtual_machine_extension" "vm-dsc" {
  name                       = "dsc"
  count                      = "${var.count}"
  location                   = "${var.region}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_machine_name       = "${var.name}-${count.index}"
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.72"
  auto_upgrade_minor_version = true
  tags                       = "${var.tags}"

  settings = <<SETTINGS
{
    "wmfVersion": "latest",
    "configurationArguments": {
      "RegistrationUrl": "${module.dsc-endpoint.secret_value}",        
      "NodeConfigurationName": "${var.dsc_configuration_name}",
      "RebootNodeIfNeeded": true,
      "ConfigurationMode": "ApplyAndAutoCorrect"
    }
}
SETTINGS

    protected_settings = <<PROTECTED_SETTINGS
{
    "configurationArguments": {
      "RegistrationKey": {
        "UserName": "placeholder",
        "Password": "${module.dsc-key.secret_value}"
      }
    }
}
PROTECTED_SETTINGS
}
