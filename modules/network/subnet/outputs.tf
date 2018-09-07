output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}

output "address_prefix" {
  value = "${azurerm_subnet.subnet.address_prefix}"
}
