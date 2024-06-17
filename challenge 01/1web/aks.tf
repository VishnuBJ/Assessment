resource "azurerm_kubernetes_cluster" "wordpress-web" {
  name                = "wordpress-aks-web"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  dns_prefix          = "webaks1"

  default_node_pool {
    name       = "web"
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
  value     = azurerm_kubernetes_cluster.wordpress-web.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.wordpress-web.kube_config_raw

  sensitive = true
}