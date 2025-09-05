resource "azurerm_public_ip" "pip" {
  name                = var.pip
  location            = var.location
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}


