resource "azurerm_virtual_network" "vnet" {
  name = "vnet-${var.workload}-${var.environment}001"
  location = var.location
  address_space = var.address_space
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  name = each.key
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.resource_group
  address_prefixes = [each.value]
}