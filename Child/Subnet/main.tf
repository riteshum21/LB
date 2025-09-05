resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
  address_prefixes     = var.address_prefixes

}


