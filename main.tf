variable "subscription_id1" {}
variable "client_id1" {}
variable "client_secret1" {}
variable "tenant_id1" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id1}"
  client_id       = "${var.client_id1}"
  client_secret   = "${var.client_secret1}"
  tenant_id       = "${var.tenant_id1}"
  
  features {

  }
}
