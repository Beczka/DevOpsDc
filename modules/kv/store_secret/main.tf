resource "azurerm_key_vault_secret" "kv-secret" {
  name      = "${var.name}"
  value     = "${var.value_to_store}"
  vault_uri = "${var.vault_uri}"
  tags =      "${var.tags}"
}
