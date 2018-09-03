output "vault_url" {
  value = "${azurerm_key_vault.kv.vault_uri}"
}
