output "vnet_name" {
  value       = local.existing_vnet_name
  description = "The name of the VNET."
}

output "location" {
  description = "The location/region where the VNET."
  value       = var.location
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = var.resource_group_name
}

output "vnet_id" {
  value       = local.vnet_id
  description = "The ID of the VNET."
}

output "vnet_cidr" {
  value       = local.vnet_cidr
  description = "The CIDR block of the VNET."
}

output "outside_subnet_ids" {
  value       = azurerm_subnet.outside[*].id
  description = "The IDs of the outside subnets."
}

output "inside_subnet_ids" {
  value       = azurerm_subnet.inside[*].id
  description = "The IDs of the inside subnets."
}

output "local_subnet_ids" {
  value       = azurerm_subnet.local[*].id
  description = "The IDs of the local subnets."
}

output "outside_subnet_names" {
  value       = azurerm_subnet.outside[*].name
  description = "The Names of the outside subnets."
}

output "inside_subnet_names" {
  value       = azurerm_subnet.inside[*].name
  description = "The Names of the inside subnets."
}

output "local_subnet_names" {
  value       = azurerm_subnet.local[*].name
  description = "The Names of the local subnets."
}

output "inside_route_table_ids" {
  value       = azurerm_route_table.inside[*].id
  description = "The IDs of the inside route tables."
}

output "inside_route_table_names" {
  value       = azurerm_route_table.inside[*].name
  description = "The names of the inside route tables."
}

output "outside_security_group_name" {
  value       = azurerm_network_security_group.outside[*].name
  description = "The Name of the outside security group."
}

output "inside_security_group_name" {
  value       = azurerm_network_security_group.inside[*].name
  description = "The Name of the inside security group."
}

output "az_names" {
  value       = local.az_names
  description = "Availability zones."
}
