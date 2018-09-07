output "vault_url" {
  value = "${azurerm_key_vault.kv.vault_uri}"
}

output "vault_id" {
  value = "${azurerm_key_vault.kv.id}"
}

