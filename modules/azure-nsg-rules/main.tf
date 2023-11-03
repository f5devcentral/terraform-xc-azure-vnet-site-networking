data "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
}

locals {
  americas_tcp_80_443_range = [
    "5.182.215.0/25",
    "84.54.61.0/25",
    "23.158.32.0/25",
    "84.54.62.0/25",
    "185.94.142.0/25",
    "185.94.143.0/25",
    "159.60.190.0/24",
    "159.60.168.0/24",
  ]
  europe_tcp_80_443_range = [
    "5.182.213.0/25",
    "5.182.212.0/25",
    "5.182.213.128/25",
    "5.182.214.0/25",
    "84.54.60.0/25",
    "185.56.154.0/25",
    "159.60.160.0/24",
    "159.60.162.0/24",
    "159.60.188.0/24",
  ]
  asia_tcp_80_443_range = [
    "103.135.56.0/25",
    "103.135.57.0/25",
    "103.135.56.128/25",
    "103.135.59.0/25",
    "103.135.58.128/25",
    "103.135.58.0/25",
    "159.60.189.0/24",
    "159.60.166.0/24",
    "159.60.164.0/24",
  ]
  americas_udp_4500_range = [
    "5.182.215.0/25",
    "84.54.61.0/25",
    "23.158.32.0/25",
    "84.54.62.0/25",
    "185.94.142.0/25",
    "185.94.143.0/25",
    "159.60.190.0/24",
  ]
  europe_udp_4500_range = [
    "5.182.213.0/25",
    "5.182.212.0/25",
    "5.182.213.128/25",
    "5.182.214.0/25",
    "84.54.60.0/25",
    "185.56.154.0/25",
    "159.60.160.0/24",
    "159.60.162.0/24",
    "159.60.188.0/24",
  ]
  asia_udp_4500_range = [
    "103.135.56.0/25",
    "103.135.57.0/25",
    "103.135.56.128/25",
    "103.135.59.0/25",
    "103.135.58.128/25",
    "103.135.58.0/25",
    "159.60.189.0/24",
    "159.60.166.0/24",
    "159.60.164.0/24",
  ]
}

resource "azurerm_network_security_rule" "americas_tcp_80_443_range" {
  name                         = "AllowAmericasTcp-80_443"
  priority                     = sum([var.priority_start, 0])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["80", "443"]
  source_address_prefixes      = local.americas_tcp_80_443_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "europe_tcp_80_443_range" {
  name                         = "AllowEuropeTcp-80_443"
  priority                     = sum([var.priority_start, 1])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["80", "443"]
  source_address_prefixes      = local.europe_tcp_80_443_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "asia_tcp_80_443_range" {
  name                         = "AllowAsiaTcp-80_443"
  priority                     = sum([var.priority_start, 2])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["80", "443"]
  source_address_prefixes      = local.asia_tcp_80_443_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "americas_udp_4500_range" {
  count =  var.create_udp_security_group_rules ? 1 : 0

  name                         = "AllowAmericasUdp-4500"
  priority                     = sum([var.priority_start, 3])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "4500"
  source_address_prefixes      = local.americas_udp_4500_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "europe_udp_4500_range" {
  count =  var.create_udp_security_group_rules ? 1 : 0

  name                         = "AllowEuropeUdp-4500"
  priority                     = sum([var.priority_start, 4])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "4500"
  source_address_prefixes      = local.europe_udp_4500_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "asia_udp_4500_range" {
  count =  var.create_udp_security_group_rules ? 1 : 0

  name                         = "AllowAsiaUdp-4500"
  priority                     = sum([var.priority_start, 5])
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "4500"
  source_address_prefixes      = local.asia_udp_4500_range
  destination_address_prefixes = setunion(var.outside_subnets, var.local_subnets)
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

## Default rules to prevent traffic from being passed through the default "140 - all" rule created by XC Cloud.

resource "azurerm_network_security_rule" "vnet" {
  count =  var.create_default_rules ? 1 : 0

  name                       = "AllowVnetInBound"
  priority                   =  sum([var.priority_start, 10])
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "load_balancer" {
  count =  var.create_default_rules ? 1 : 0

  name                       = "AllowAzureLoadBalancerInBound"
  priority                   =  sum([var.priority_start, 11])
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "AzureLoadBalancer"
  destination_address_prefix = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_security_rule" "deny_other" {
  count =  var.create_default_rules ? 1 : 0

  name                       = "DenyOther"
  priority                   =  sum([var.priority_start, 12])
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}