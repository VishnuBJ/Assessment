# Subnet
resource "azurerm_subnet" "app" {
  name                 = "appSubnet"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "appNSG"
  resource_group_name = azurerm_resource_group.wordpress.name
  location            = azurerm_resource_group.wordpress.location

  security_rule {
    name                       = "AllowFrontendInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"  // Allow inbound traffic from frontend subnet
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowMySQL"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"  # MySQL default port
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = azurerm_mysql_server.wordpress.id
  }

  security_rule {
    name                       = "AllowOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"  // Allow outbound traffic to frontend subnet
    destination_address_prefix = "*"
  }
  
}

# Associating network security group with app subnet
resource "azurerm_subnet_network_security_group_association" "app_nsg_sub" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_lb" "app-lb" {
  name                = "AppLoadBalancer"
  resource_group_name = azurerm_resource_group.wordpress.name
  location            = azurerm_resource_group.wordpress.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "PrivateIpAddress"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"  
  }
}

resource "azurerm_lb_backend_address_pool" "back-ap-app" {
  loadbalancer_id = azurerm_lb.app-lb.id
  name            = "BackEndAddressPoolApp"
}