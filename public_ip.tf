resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
  location            = azurerm_resource_group.vnet_vpn_rg.location
  allocation_method   = "Dynamic" # You can use "Static" if you want a static IP address
}