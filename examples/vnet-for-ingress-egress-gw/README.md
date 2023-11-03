# Azure VNET for F5 XC Cloud Ingress/Egress GW Azure VNET Site

The following example will create an Azure VNET with 3 AZs, 3 subnets per AZ, and a security group. The security groups will be configured with whitelisted IP ranges for the XC Cloud Ingress/Egress GW Azure VNET Site.

```hcl
module "azure_vnet" {
  source = "../.."

  create_resource_group = false
  resource_group_name = "azure_terraform_demo"
  location = var.azure_rg_location
  vnet_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
}
```