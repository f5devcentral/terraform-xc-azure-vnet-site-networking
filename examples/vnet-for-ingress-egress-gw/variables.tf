variable "azure_rg_location" {
  type    = string
  default = "westus2"
}

variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "azure_subscription_tenant_id" {
  type    = string
  default = ""
}

variable "azure_service_principal_appid" {
  type    = string
  default = ""
}

variable "azure_service_principal_password" {
  type    = string
  default = ""
}