terraform {
  required_version = ">= 1.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-shared-pr001"
    storage_account_name = "sttfstatepr001"
    container_name       = "tfstate"
    key                  = "az-landing-zone.tfstate"
  }

}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "hub" {
  name     = "rg-${var.project_name}-${var.environment}001"
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                     = "stterraformstatedv001"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.storage_replication_type
}

module "hub_vnet" {
  source         = "./modules/networking"
  environment    = var.environment
  workload       = "hub"
  location       = var.location
  resource_group = azurerm_resource_group.hub.name
  address_space  = ["10.0.0.0/16"]
  subnets = {
    "AzureFirewallSubnet" = "10.0.1.0/26"
    "AzureBastionSubnet"  = "10.0.2.0/27"
  }
}

module "spoke_vnet" {
  source         = "./modules/networking"
  environment    = var.environment
  workload       = "spoke"
  location       = var.location
  resource_group = azurerm_resource_group.hub.name
  address_space  = ["10.1.0.0/16"]
  subnets = {
    "snet-spoke-${var.environment}001" = "10.1.1.0/24"
  }
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke-pr001"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = module.hub_vnet.vnet_name
  remote_virtual_network_id = module.spoke_vnet.vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub-pr001"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = module.spoke_vnet.vnet_name
  remote_virtual_network_id = module.hub_vnet.vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

