resource "azurerm_network_interface" "nic" {
  name                = var.nic
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm
  resource_group_name = var.rg
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "riteshvm"
  admin_password      = "Factor@666666"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.nic.id,

  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "nic" {
  value = azurerm_network_interface.nic.id
}

