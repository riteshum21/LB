terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
    backend "azurerm" {

    storage_account_name = "riteshstg"                              
    container_name       = "riteshcnt"                               
    key                  = "tfstate"           
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "879e262b-becf-4bea-a163-835b023ba8e0"
}
