resource "azurerm_virtual_network_gateway" "vngw" {
  name                = "vnet-gateway"
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
  location            = azurerm_resource_group.vnet_vpn_rg.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  generation          = "Generation1"
  # The available values depend on the type and sku arguments - where Generation2 is only value for a sku larger than VpnGw2 or VpnGw2AZ.

  active_active = false

  # (Optional) If true, an active-active Virtual Network Gateway will be created. 
  # An active-active gateway requires a HighPerformance or an UltraPerformance SKU. 
  # If false, an active-standby gateway will be created. Defaults to false.

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = azurerm_subnet.public_subnet_2.id
  }

  dynamic "vpn_client_configuration" {

    for_each = var.isSiteToSiteVPNSetup ? [] : [1] # Create the block only if isSiteToSiteVPNSetup is false 
                                               # For now we are assuming if it is not Site-To-Site, it is point to site   
    content {
            address_space = ["172.16.0.0/16"] # Address space for P2S clients
            root_certificate {
                name = "RootCertificate"
                # Replace with your base64-encoded root certificate
                # Better Read from a file
                # public_cert_data = filebase64("${path.module}/${var.root_cert_file}")
                public_cert_data = <<EOF
YOUR CERTIFICATE IN BASE64 WITHOUT -----BEGIN CERTIFICATE----- and -----END CERTIFICATE-----
EOF
        }
    }
  }

}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  count               = var.isSiteToSiteVPNSetup ? 1 : 0
  name                = "onpremise"
  location            = azurerm_resource_group.vnet_vpn_rg.location
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gw[count.index].id

  shared_key = "a-v3ry-53cr8-1p53c-5hr3d-k3y"
}