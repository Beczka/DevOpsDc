resource "random_string" "password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
}

resource "azurerm_key_vault_secret" "secret-password" {
  name      = "${var.name}"
  value     = "${random_string.password.result}"
  vault_uri = "${var.vault_uri}"

  tags = "${var.tags}"
}
