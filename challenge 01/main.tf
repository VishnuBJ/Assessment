terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create a resource group
resource "azurerm_resource_group" "wordpress" {
  name     = "wordpress-rg"
  location = "centralindia"
}

# Virtual Network
resource "azurerm_virtual_network" "wordpress" {
  name                = "wordpressVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
}

