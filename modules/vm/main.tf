# Add if needed
# resource "azurerm_availability_set" "scale-set" {
#   name                = "${var.name}-scale-set"
#   location            = "${var.region}"
#   resource_group_name = "${var.resource_group_name}"
#   tags                = "${var.tags}"
#   managed             = true
# }

module "windows-admin" {
  source    = "../kv/create_and_store_secret"
  name      = "vmadministrator"
  vault_uri = "${var.vault_url}"
}

resource "azurerm_public_ip" "vm" {
  count                        = "${var.count}"
  name                         = "${var.name}-ip-${count.index}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"
  location                     = "${var.region}"
  tags                         = "${var.tags}"
}

resource "azurerm_network_interface" "vm" {
  count               = "${var.count}"
  name                = "${var.name}-nic-${count.index}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "default"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.vm.*.id, count.index)}"
  }
}

resource "azurerm_managed_disk" "vm-data" {
  name                 = "${var.name}-${count.index}-data-disk"
  location             = "${var.region}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 200
  count                = "${var.count}"
  tags                 = "${var.tags}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.name}-${count.index}"
  count                 = "${var.count}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.region}"
  network_interface_ids = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  vm_size               = "Standard_D2s_v3"
  tags                  = "${var.tags}"
  # Add if needed
  # availability_set_id   = "${var.count == "1" ? "0" : "${azurerm_availability_set.scale-set.id}"}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}-mainos-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.vm-data.*.name[count.index]}"
    managed_disk_id = "${azurerm_managed_disk.vm-data.*.id[count.index]}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.vm-data.*.disk_size_gb[count.index]}"
  }

  os_profile {
    computer_name  = "vm-${count.index}"
    admin_username = "vmadministrator"
    admin_password = "${module.windows-admin.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

module "vm-dsc" {
  source                 = "./extension/dsc"
  count                  = "${var.count}"
  vault_url              = "${var.vault_url}"
  name                   = "${var.name}"
  count                  = "${var.count}"
  region                 = "${var.region}"
  tags                   = "${var.tags}"
  resource_group_name    = "${var.resource_group_name}"
  virtual_machine_name   = "${var.name}"
  dsc_configuration_name = "AppServer.MirrorCheck"
}
