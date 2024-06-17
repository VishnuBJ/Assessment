resource "azurerm_kubernetes_cluster" "wordpress-app" {
  name                = "wordpress-aks-app"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  dns_prefix          = "appaks1"

  default_node_pool {
    name       = "app"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.wordpress-app.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.wordpress-app.kube_config_raw

  sensitive = true
}