terraform {
  required_version = ">= 1.4.0"
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.7.2"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = "=0.11.44"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.39.0"
    }
  }
}
