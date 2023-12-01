resource "azurerm_local_network_gateway" "local_network_gw" {
  count               = var.isSiteToSiteVPNSetup ? 1 : 0
  name                = "local_nw_gw"
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
  location            = azurerm_resource_group.vnet_vpn_rg.location
  gateway_address     = var.local_network_gateway_public_ip # Replace with your on-premises VPN device's public IP address

  address_space = ["192.168.1.0/24"] # Replace with your on-premises network or router address space

}