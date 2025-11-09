terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "tfstateaccount1710"
    container_name       = "tfstateaccount"
    key                  = "aks.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

variable "secrets" {
  type = map(string)
  default = {
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    client_id = var.client_id
  }
}

provider "azurerm" {
  features {}
}