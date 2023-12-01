resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-for-vpn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vnet_vpn_rg.location
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
}

resource "azurerm_subnet" "private_subnet_1" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.vnet_vpn_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = [
    "Microsoft.Sql",
  ]
}

resource "azurerm_subnet" "private_subnet_2" {
  name                 = "private-subnet-2"
  resource_group_name  = azurerm_resource_group.vnet_vpn_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "public_subnet_1" {
  name                 = "public-subnet-1"
  resource_group_name  = azurerm_resource_group.vnet_vpn_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}
# Consider this as a Virtual Network Gateway Subnet
resource "azurerm_subnet" "public_subnet_2" {
  name                 = "GatewaySubnet" # You must put the name GatewaySubnet
  resource_group_name  = azurerm_resource_group.vnet_vpn_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}