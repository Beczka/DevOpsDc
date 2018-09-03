data "azurerm_key_vault_secret" "secret" {
  name      = "${var.name}"
  vault_uri = "${var.vault_uri}"
}
