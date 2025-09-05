data "azurerm_public_ip" "pip" {
  name                = var.pip
  resource_group_name = var.rg
}
