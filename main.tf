terraform {
  required_version = ">= 1.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-hub-dv001"
    storage_account_name = "stterraformstatedv001"
    container_name       = "tfstate"
    key                  = "landing-zone.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "hub" {
  name     = "rg-hub-dv001"
  location = "East US"
}

resource "azurerm_storage_account" "state" {
  name                     = "stterraformstatedv001"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}