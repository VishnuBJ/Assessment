# Subnet
resource "azurerm_subnet" "data" {
  name                 = "dataSubnet"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = ["10.0.3.0/24"]
}