data "azurerm_subnet" "subnet" {
  name                 = var.subnet
  virtual_network_name = var.vnet
  resource_group_name  = var.rg

}
