# Azure Networking module for F5 Distributed Cloud (XC) Azure VNET Site

This Terraform module provisions an Azure VNET that is required for XC Cloud Azure VNET Site. It creates a VNET, subnets, route tables, and network security groups with whitelisted IP ranges.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) | >= 3.0 |
| <a name="requirement_random"></a> [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs) | >= 3.0 |

## Usage


To use this module and create a Azure VNET configured for XC Cloud Azure VNET Site, include the following code in your Terraform configuration:

```hcl
module "azure_vnet" {
  source  = "f5devcentral/azure-vnet-site-networking/volterra"
  version = "0.0.1"

  resource_group_name = "azure_terraform_demo"
  location = var.azure_rg_location
  vnet_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
}
```

## Contributing

Contributions to this module are welcome! Please see the contribution guidelines for more information.

## License

This module is licensed under the Apache 2.0 License.