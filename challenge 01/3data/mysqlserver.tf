resource "azurerm_mysql_server" "wordpress" {
  name                = "wordpress-mysqlserver"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# Allow all Azure services and IPs to access the MySQL server for simplicity/testing
resource "azurerm_mysql_firewall_rule" "mysqlserver-fw" {
  name                = "all"
  resource_group_name = azurerm_resource_group.wordpress.name
  server_name         = azurerm_mysql_server.wordpress.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}