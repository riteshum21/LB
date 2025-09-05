module "rg" {
  source   = "../Child/RG"
  rg       = "rg"
  location = "japaneast"
}

module "vnet" {
  source        = "../Child/Vnet"
  depends_on    = [module.rg]
  rg            = "rg"
  vnet          = "lbvnet"
  location      = "japaneast"
  address_space = ["10.1.0.0/16"]

}

module "vnet1" {
  source        = "../Child/Vnet"
  depends_on    = [module.rg]
  rg            = "rg"
  vnet          = "Peeringvnet"
  location      = "japaneast"
  address_space = ["10.0.0.0/16"]

}
module "subnet" {
  source           = "../Child/Subnet"
  depends_on       = [module.vnet]
  subnet           = "lbsubnet"
  rg               = "rg"
  vnet             = "lbvnet"
  address_prefixes = ["10.1.0.0/24"]
}

module "subnet1" {
  source           = "../Child/Subnet"
  depends_on       = [module.vnet]
  subnet           = "AzureBastionSubnet"
  rg               = "rg"
  vnet             = "lbvnet"
  address_prefixes = ["10.1.1.0/24"]
}


module "bastion" {
  source     = "../Child/Bastion"
  depends_on = [module.subnet1,module.rg,module.vnet]
  bastion    = "lbbastion"
  rg         = "rg"
  location   = "japaneast"
  vnet       = "lbvnet"
  subnet     = "AzureBastionSubnet"
  pip        = "baspip"
}

module "pip1" {
  source     = "../Child/PIP"
  depends_on = [module.rg]
  rg         = "rg"
  location   = "japaneast"
  pip        = "baspip"
}

module "pip2" {
  source     = "../Child/PIP"
  depends_on = [module.rg]
  rg         = "rg"
  location   = "japaneast"
  pip        = "lbpip"
}

module "vm1" {
  source     = "../Child/VM"
  depends_on = [module.subnet]
  nic        = "nic1"
  location   = "japaneast"
  rg         = "rg"
  subnet     = "lbsubnet"
  vnet       = "lbvnet"
  vm         = "lbvm1"
}

module "vm2" {
  source     = "../Child/VM"
  depends_on = [module.subnet]
  nic        = "nic2"
  location   = "japaneast"
  rg         = "rg"
  subnet     = "lbsubnet"
  vnet       = "lbvnet"
  vm         = "lbvm2"
}

module "lb" {
  source   = "../Child/Loadbalancer"
  depends_on = [ module.subnet, module.pip2 ]
  location = "japaneast"
  rg       = "rg"
  lb       = "loadbalancer"
  pip      = "lbpip"
  nic = [
    module.vm1.nic,
    module.vm2.nic
  ]
}
