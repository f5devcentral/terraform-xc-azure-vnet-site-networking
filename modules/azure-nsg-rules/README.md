# Azure NSG Rules Module for F5 Distributed Cloud

This submodule creates Azure Network Security Group (NSG) rules specifically designed for F5 Distributed Cloud (XC) connectivity. It applies pre-configured security rules that allow traffic from F5 XC regional data centers while maintaining security best practices.

## Purpose

This module is designed to be used internally by the parent `azure-vnet-site-networking` module. It creates the necessary NSG rules to allow F5 Distributed Cloud traffic while blocking unauthorized access.

## Security Rules Created

The module creates the following types of security rules:

### F5 XC Regional Traffic Rules
- **Americas TCP 80/443**: Allows HTTP/HTTPS traffic from F5 XC Americas region
- **Europe TCP 80/443**: Allows HTTP/HTTPS traffic from F5 XC Europe region  
- **Asia TCP 80/443**: Allows HTTP/HTTPS traffic from F5 XC Asia region
- **Americas UDP 4500**: Allows IPSec/IKE traffic from F5 XC Americas region
- **Europe UDP 4500**: Allows IPSec/IKE traffic from F5 XC Europe region
- **Asia UDP 4500**: Allows IPSec/IKE traffic from F5 XC Asia region

### Default Traffic Rules
- **VNET Communication**: Allows communication within the VNET subnets
- **Load Balancer Access**: Allows Azure Load Balancer health probes
- **Deny All Other**: Denies all other inbound traffic (default deny)

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.4.0  |
| azurerm   | >= 4.39.0 |

## Usage

This module is typically used internally by the parent module, but can be used standalone:

```hcl
module "nsg_rules" {
  source = "./modules/azure-nsg-rules"

  resource_group_name         = "my-resource-group"
  network_security_group_name = "my-nsg"
  outside_subnets            = ["10.0.1.0/24", "10.0.2.0/24"]
  local_subnets              = ["10.0.10.0/24", "10.0.11.0/24"]
  create_udp_security_group_rules = true
  priority_start             = 120
}
```

## Inputs

| Name                            | Description                                              | Type           | Default |
| ------------------------------- | -------------------------------------------------------- | -------------- | ------- |
| resource_group_name             | The name of the resource group containing the NSG        | `string`       | n/a     |
| network_security_group_name     | The name of the network security group to add rules to   | `string`       | n/a     |
| outside_subnets                 | A list of CIDR blocks for the outside subnets            | `list(string)` | `[]`    |
| local_subnets                   | A list of CIDR blocks for the local subnets              | `list(string)` | `[]`    |
| create_udp_security_group_rules | Whether to create UDP security group rules for IPSec/IKE | `bool`         | `true`  |
| priority_start                  | The starting priority for the security rules             | `number`       | `120`   |
| create_default_rules            | Whether to create default VNET and deny rules            | `bool`         | `true`  |

## Outputs

This module does not expose any outputs.

## F5 XC IP Ranges

The module includes F5 Distributed Cloud IP ranges for all regions (Americas, Europe, and Asia) for both TCP (80/443) and UDP (4500) traffic.

For the current and complete list of F5 Distributed Cloud IP ranges, please refer to the official documentation:

**[F5 Distributed Cloud Network Reference](https://docs.cloud.f5.com/docs-v2/platform/reference/network-cloud-ref)**

> **Note**: F5 XC IP ranges may change over time. This module contains the IP ranges that were current at the time of release. For the most up-to-date ranges, always consult the official F5 documentation above.

## Maintenance

This module requires periodic updates to maintain current F5 XC IP ranges. Monitor F5 documentation for any changes to regional IP ranges.

## License

This module is licensed under the Apache 2.0 License.
