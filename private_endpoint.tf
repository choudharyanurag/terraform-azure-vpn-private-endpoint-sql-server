resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "sql_private-endpoint"
  location            = azurerm_resource_group.vnet_vpn_rg.location
  resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
  subnet_id           = azurerm_subnet.private_subnet_1.id


  private_service_connection {
    name                           = "sql-server-connection"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    # private_ip_address             = azurerm_network_interface.private_nic.private_ip_address
    is_manual_connection          = false
  }
}

# Can't configure a value for "private_service_connection.0.private_ip_address": its value will be decided automatically based on the result of applying this configuration.

# resource "azurerm_network_interface" "private_nic" {
#   name                = "sql_private_nic"
#   resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
#   location            = azurerm_resource_group.vnet_vpn_rg.location

#   ip_configuration {
#     name                          = "private-ip-config-sql-subnet-1"
#     subnet_id                     = azurerm_subnet.private_subnet_1.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }