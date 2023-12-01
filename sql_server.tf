resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-server-anurag-vpn-check"
  resource_group_name          = azurerm_resource_group.vnet_vpn_rg.name
  location                     = azurerm_resource_group.vnet_vpn_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "C0mplexPwd!" # Replace with your strong password

  public_network_access_enabled = false 

}

resource "azurerm_mssql_database" "sql_database" {
  name                = "sql-database"
  server_id         = azurerm_mssql_server.sql_server.id
  sku_name          = "S0"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 1

}

# resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
#   name                = "sql-vnet-rule"
#   resource_group_name = azurerm_resource_group.vnet_vpn_rg.name
#   server_name         = azurerm_sql_server.sql_server.name
#   subnet_id           = azurerm_subnet.private_subnet_1.id
# }

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}