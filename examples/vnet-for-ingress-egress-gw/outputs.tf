output "vnet_name" {
  value       = module.azure_vnet.vnet_name
  description = "The name of the VNET."
}

output "location" {
  description = "The location/region where the VNET."
  value       = module.azure_vnet.location
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.azure_vnet.resource_group_name
}

output "vnet_id" {
  value       = module.azure_vnet.vnet_id
  description = "The ID of the VNET."
}

output "vnet_cidr" {
  value       = module.azure_vnet.vnet_cidr
  description = "The CIDR block of the VNET."
}

output "outside_subnet_ids" {
  value       = module.azure_vnet.outside_subnet_ids
  description = "The IDs of the outside subnets."
}

output "inside_subnet_ids" {
  value       = module.azure_vnet.inside_subnet_ids
  description = "The IDs of the inside subnets."
}

output "local_subnet_ids" {
  value       = module.azure_vnet.local_subnet_ids
  description = "The IDs of the local subnets."
}

output "outside_security_group_name" {
  value       = module.azure_vnet.outside_security_group_name
  description = "The Name of the outside security group."
}

output "inside_security_group_name" {
  value       = module.azure_vnet.inside_security_group_name
  description = "The Name of the inside security group."
}

output "az_names" {
  value       = module.azure_vnet.az_names
  description = "Availability zones."
}