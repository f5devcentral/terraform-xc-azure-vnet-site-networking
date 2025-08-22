resource "random_string" "random" {
  length  = 8
  special = false
  numeric = false
  lower   = true
}

locals {
  create_outside_subnet = local.outside_subnets_len > 0
  create_local_subnet   = local.local_subnets_len > 0
  create_inside_subnet  = local.inside_subnets_len > 0
  outside_subnets_len   = length(var.outside_subnets)
  local_subnets_len     = length(var.local_subnets)
  inside_subnets_len    = length(var.inside_subnets)
  resource_group_name   = var.resource_group_name
  vnet_name             = var.name != null ? var.name : format("%s-vnet", random_string.random.result)
  vnet_id               = var.create_vnet ? azurerm_virtual_network.this[0].id : data.azurerm_virtual_network.this[0].id
  vnet_cidr             = var.create_vnet ? tolist(azurerm_virtual_network.this[0].address_space)[0] : tolist(data.azurerm_virtual_network.this[0].address_space)[0]
  existing_vnet_name    = var.create_vnet ? azurerm_virtual_network.this[0].name : local.vnet_name
  az_names              = slice(["1", "2", "3"], 0, max(local.outside_subnets_len, local.local_subnets_len, local.inside_subnets_len))

  common_tags = merge(var.tags, {
    Name        = local.vnet_name
    Environment = lookup(var.tags, "Environment", "dev")
  })
}

resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = local.resource_group_name
  location = var.location

  tags = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }
}

data "azurerm_virtual_network" "this" {
  count = var.create_vnet ? 0 : 1

  name                = local.existing_vnet_name
  resource_group_name = var.location
}

resource "azurerm_virtual_network" "this" {
  count = var.create_vnet ? 1 : 0

  name          = local.vnet_name
  address_space = [var.vnet_cidr]

  location            = var.location
  resource_group_name = local.resource_group_name

  tags = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}

resource "azurerm_subnet" "local" {
  count = local.create_local_subnet ? local.local_subnets_len : 0

  name                 = format("${local.existing_vnet_name}-local-%s", element(local.az_names, count.index))
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.existing_vnet_name
  address_prefixes     = [element(var.local_subnets, count.index)]

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_subnet" "outside" {
  count = local.create_outside_subnet ? local.outside_subnets_len : 0

  name                 = format("${local.existing_vnet_name}-outside-%s", element(local.az_names, count.index))
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.existing_vnet_name
  address_prefixes     = [element(var.outside_subnets, count.index)]

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_subnet" "inside" {
  count = local.create_inside_subnet ? local.inside_subnets_len : 0

  name                 = format("${local.existing_vnet_name}-inside-%s", element(local.az_names, count.index))
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.existing_vnet_name
  address_prefixes     = [element(var.inside_subnets, count.index)]

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_network_security_group" "outside" {
  count = var.create_outside_security_group ? 1 : 0

  name                = format("%s-outside-nsg", local.vnet_name)
  location            = var.location
  resource_group_name = local.resource_group_name

  tags = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this
  ]
}

module "outside_nsg_rules" {
  count = var.create_outside_security_group ? 1 : 0

  source = "./modules/azure-nsg-rules"

  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.outside[0].name
  outside_subnets             = var.outside_subnets
  local_subnets               = var.local_subnets

  depends_on = [
    azurerm_resource_group.this,
    azurerm_network_security_group.outside
  ]
}

resource "azurerm_network_security_group" "inside" {
  count = var.create_inside_security_group ? 1 : 0

  name                = format("%s-inside-nsg", local.vnet_name)
  location            = var.location
  resource_group_name = local.resource_group_name

  tags = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_subnet_network_security_group_association" "outside" {
  count = var.create_outside_security_group && local.create_outside_subnet ? local.outside_subnets_len : 0

  subnet_id                 = azurerm_subnet.outside[count.index].id
  network_security_group_id = azurerm_network_security_group.outside[0].id
}

resource "azurerm_subnet_network_security_group_association" "local" {
  count = var.create_outside_security_group && local.create_local_subnet ? local.local_subnets_len : 0

  subnet_id                 = azurerm_subnet.local[count.index].id
  network_security_group_id = azurerm_network_security_group.outside[0].id
}

resource "azurerm_subnet_network_security_group_association" "inside" {
  count = var.create_inside_security_group && local.create_inside_subnet ? local.inside_subnets_len : 0

  subnet_id                 = azurerm_subnet.inside[count.index].id
  network_security_group_id = azurerm_network_security_group.inside[0].id
}

resource "azurerm_route_table" "inside" {
  count = var.create_inside_route_table && local.create_inside_subnet ? local.inside_subnets_len : 0

  name                          = format("%s-inside-rt-%d", local.vnet_name, count.index)
  location                      = var.location
  resource_group_name           = local.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled

  tags = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_subnet_route_table_association" "inside" {
  count = var.create_inside_route_table && local.create_inside_subnet ? local.inside_subnets_len : 0

  subnet_id      = azurerm_subnet.inside[count.index].id
  route_table_id = azurerm_route_table.inside[count.index].id

  depends_on = [
    azurerm_subnet.inside,
    azurerm_route_table.inside,
  ]
}
