provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_subscription_tenant_id
  client_id       = var.azure_service_principal_appid
  client_secret   = var.azure_service_principal_password
}

module "azure_vnet" {
  source = "../.."

  create_resource_group = false
  resource_group_name = "azure_terraform_demo"
  location            = var.azure_rg_location
  vnet_cidr           = "192.168.0.0/16"
  outside_subnets     = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets      = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
}
