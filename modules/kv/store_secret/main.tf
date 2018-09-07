resource "azurerm_key_vault_secret" "kv-secret" {
  count     = "${var.count}"
  name      = "${lookup(var.secrets[count.index], "name")}"
  value      ="${lookup(var.secrets[count.index], "value_to_store")}"
  vault_uri = "${var.vault_uri}"
}
