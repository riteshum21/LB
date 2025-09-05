resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  resource_group_name = var.rg
  location            = var.location
  address_space       = var.address_space
}


