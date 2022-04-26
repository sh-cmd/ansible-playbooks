resource "azurerm_resource_group" "main" {
  name     = "${var.rg_name}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.vnet_name}-network"
  address_space       = ["${var.cidr_vnet}"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
 
  name                 = "${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${var.cidr_subnet}"]
  
}