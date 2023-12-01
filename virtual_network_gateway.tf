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
MIIC3zCCAcegAwIBAgIQL7VEsj7uWqZD7Z4eO5pp3TANBgkqhkiG9w0BAQsFADAS
MRAwDgYDVQQDDAdWUE5Sb290MB4XDTIzMTIwMTA0NTczNloXDTI0MTIwMTA1MTcz
NlowEjEQMA4GA1UEAwwHVlBOUm9vdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAKxqAP3sZY886ko2D6uceLLzja/qJehrnc9feYMLzNa14rpzKr4vQQ4H
9pw5CXY3oBBKL2jk3orxpkBxJQw3DDzjTgp6KoDbtXJqOGjk5UyyXPbj+jqWAHEx
/n+POAi/pWWoaYkewyWThjy6RXYU9cuW22ynV6i7PN4B4EdfuSr6wU03QMjuQq3l
3oq3QqAux/kS26+jmKYtFeeTnqFQlYSc1w5CAHX+Dx6qFaotDvgrvDGOR4JZnttt
7WIjPjiQ8FU/EJLWCdKeEhP2+BXSGMhTdIxB51XbkyMNKxJawKS758YPmfzc+DXw
0CyWJvMHliTqrO6SmUKP/2bEEneFl4ECAwEAAaMxMC8wDgYDVR0PAQH/BAQDAgIE
MB0GA1UdDgQWBBQyjvVG7An1vAs82562aNANg+W62zANBgkqhkiG9w0BAQsFAAOC
AQEAF8wo0h0lhi/RKAYzs5gKutAQDc6/loNIaZLkj/4CiuaPcSUSfmqvivTHI3TW
rN8siGCA27EALtY4hNkGa3PjB4ji1vf1dWfMF0j7lMo814QwWrAaAxxk35jQ1yPP
BH6FuZRRnOq6+GAo62rJda+YGTKD0+gPDMlV55pP74FB3JQay5Yk4GVhWukxaGvY
vKSw6w+9cW4jtPrXeaUAN5V6dhcseXdLGfsk43tVNZY5cXk09WAYvPKzpwJQolJR
Nt2sul0uIfi8LN7KgvvuDJYsyO3a+6N3OJd3cUT7VFvia82sPE3JwOap0jQ6nB55
aN+4034BBdpaMuhbaQp9QwCHUg==
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