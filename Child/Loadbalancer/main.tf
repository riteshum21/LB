resource "azurerm_lb" "lb" {
  name                = var.lb
  location            = var.location
  resource_group_name = var.rg
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "fip"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "bepool" {
  name                = "backendpool"
  loadbalancer_id     = azurerm_lb.lb.id
}

# Health probe (HTTP on 80)
resource "azurerm_lb_probe" "probe" {
  name                = "http-probe-80"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

# LB Rule: Public 80 -> Backend 80
resource "azurerm_lb_rule" "lbrule" {
  name                           = "http-80"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "fip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

# # ---------- Availability Set (for 2 VMs) ----------
# resource "azurerm_availability_set" "aset" {
#   name                         = "${local.name_prefix}-aset"
#   location                     = azurerm_resource_group.rg.location
#   resource_group_name          = azurerm_resource_group.rg.name
#   platform_fault_domain_count  = 2
#   platform_update_domain_count = 5
#   managed                      = true
# }

# # ---------- NICs + association to LB backend ----------
# resource "azurerm_network_interface" "nic" {
#    name                = var.nic
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }


resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each = {
    nic1 = var.nic[0]
    nic2 = var.nic[1]
  }

  network_interface_id    = each.value
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}