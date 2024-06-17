# Subnet
resource "azurerm_subnet" "web" {
  name                 = "webSubnet"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = "webNSG"
  resource_group_name = azurerm_resource_group.wordpress.name
  location            = azurerm_resource_group.wordpress.location

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"  // Allow outbound traffic to backend subnet
  }
}

# Associating network security group with web subnet
resource "azurerm_subnet_network_security_group_association" "web_nsg_sub" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_public_ip" "lb-pip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "web-lb" {
  name                = "WebLoadBalancer"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "back-ap-web" {
  loadbalancer_id = azurerm_lb.web-lb.id
  name            = "BackEndAddressPoolWeb"
}
