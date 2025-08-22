variable "resource_group_name" {
  description = "The name of the resource group in which to create the VNET. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "network_security_group_name" {
  description = "The name of the network security group in which to create the rules. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "create_udp_security_group_rules" {
  description = "Whether to create UDP security group rules."
  type        = bool
  default     = true
}

variable "outside_subnets" {
  description = "A list of CIDR blocks for the outside subnets."
  type        = list(string)
  default     = []
}

variable "local_subnets" {
  description = "A list of CIDR blocks for the local subnets."
  type        = list(string)
  default     = []
}

variable "priority_start" {
  description = "The starting priority for the rules."
  type        = number
  default     = 120
}

variable "create_default_rules" {
  description = "Whether to create default rules."
  type        = bool
  default     = true
}