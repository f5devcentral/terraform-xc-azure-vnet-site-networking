# Azure Networking module for F5 Distributed Cloud (XC) Azure VNET Site

This Terraform module provisions an Azure VNET that is required for XC Cloud Azure VNET Site. It creates a VNET, subnets, route tables, and network security groups with whitelisted IP ranges.

> **Note**: This module is developed and maintained by the [F5 DevCentral](https://github.com/f5devcentral) community. You can use this module as an example for your own development projects.

## Features

- Creates Azure Virtual Network with configurable CIDR blocks
- Supports multiple subnet types: outside, inside, and local subnets
- Configurable network security groups with customizable rules
- Route tables for inside subnets with BGP route propagation control
- Multi-availability zone support
- Flexible resource group management (create new or use existing)
- Comprehensive tagging support

## Requirements

| Name                                                                                                                | Version   |
| ------------------------------------------------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform)                            | >= 1.4.0  |
| <a name="requirement_azurerm"></a> [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) | >= 4.39.0 |
| <a name="requirement_random"></a> [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)    | >= 3.7.2  |

## Usage

### Basic Example

To use this module and create an Azure VNET configured for XC Cloud Azure VNET Site, include the following code in your Terraform configuration:

```hcl
module "azure_vnet" {
  source  = "f5devcentral/azure-vnet-site-networking/xc"
  version = "0.0.4"

  resource_group_name = "azure_terraform_demo"
  location           = "East US"
  vnet_cidr          = "192.168.0.0/16"
  outside_subnets    = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets     = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  local_subnets      = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]

  tags = {
    Environment = "production"
    Project     = "xc-azure-site"
  }
}
```

### Using Existing Resource Group

```hcl
module "azure_vnet" {
  source  = "f5devcentral/azure-vnet-site-networking/xc"
  version = "0.0.4"

  create_resource_group = false
  resource_group_name   = "existing-rg"
  location             = "West US 2"
  name                 = "my-xc-vnet"
  vnet_cidr            = "10.0.0.0/16"
  outside_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  inside_subnets       = ["10.0.11.0/24", "10.0.12.0/24"]
}
```

## Inputs

| Name                          | Description                                                                                                    | Type           | Default |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------- | -------------- | ------- |
| bgp_route_propagation_enabled | Whether to enable BGP route propagation.                                                                       | `bool`         | `true`  |
| create_inside_route_table     | Whether to create an inside route table for the inside subnets.                                                | `bool`         | `true`  |
| create_inside_security_group  | Whether to create an inside security group.                                                                    | `bool`         | `true`  |
| create_outside_security_group | Whether to create an outside security group.                                                                   | `bool`         | `true`  |
| create_resource_group         | Whether to create a new resource group for the VNET. Changing this forces a new resource to be created.        | `bool`         | `true`  |
| create_vnet                   | Whether to create a new VNET. Changing this forces a new resource to be created.                               | `bool`         | `true`  |
| inside_subnets                | Inside Subnet CIDR Blocks.                                                                                     | `list(string)` | `[]`    |
| local_subnets                 | Local Subnet CIDR Blocks.                                                                                      | `list(string)` | `[]`    |
| location                      | The location/region where the VNET will be created. Changing this forces a new resource to be created.         | `string`       | n/a     |
| name                          | The name of the VNET.                                                                                          | `string`       | `null`  |
| outside_subnets               | Outside Subnet CIDR Blocks.                                                                                    | `list(string)` | `[]`    |
| resource_group_name           | The name of the resource group in which to create the VNET. Changing this forces a new resource to be created. | `string`       | n/a     |
| tags                          | A map of tags to add to all resources.                                                                         | `map(string)`  | `{}`    |
| vnet_cidr                     | The Primary IPv4 block cannot be modified. All subnets prefixes in this VNET must be part of this CIDR block.  | `string`       | `null`  |

## Outputs

| Name                        | Description                             |
| --------------------------- | --------------------------------------- |
| az_names                    | Availability zones.                     |
| inside_route_table_ids      | The IDs of the inside route tables.     |
| inside_route_table_names    | The names of the inside route tables.   |
| inside_security_group_name  | The Name of the inside security group.  |
| inside_subnet_ids           | The IDs of the inside subnets.          |
| inside_subnet_names         | The Names of the inside subnets.        |
| local_subnet_ids            | The IDs of the local subnets.           |
| local_subnet_names          | The Names of the local subnets.         |
| location                    | The location/region where the VNET.     |
| outside_security_group_name | The Name of the outside security group. |
| outside_subnet_ids          | The IDs of the outside subnets.         |
| outside_subnet_names        | The Names of the outside subnets.       |
| resource_group_name         | The name of the resource group.         |
| vnet_cidr                   | The CIDR block of the VNET.             |
| vnet_id                     | The ID of the VNET.                     |
| vnet_name                   | The name of the VNET.                   |

## Examples

For detailed examples, please check the `examples/` directory:

- [vnet-for-ingress-egress-gw](./examples/vnet-for-ingress-egress-gw/) - Example for creating a VNET for XC Cloud Ingress/Egress Gateway

## Modules

This module includes the following sub-modules:

- `azure-nsg-rules` - Creates and manages Network Security Group rules for the outside subnets

## Contributing

Contributions to this module are welcome! Please see the contribution guidelines for more information.

## License

This module is licensed under the Apache 2.0 License.