resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = false
  tags = {
    yor_trace   = "93837305-d982-473d-8aa5-f9cb7ee57c91"
    StoreStatus = "DND"
  }
}



resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name           = "default"
    node_count     = var.aks_cluster_count
    vm_size        = var.aks_cluster_size
    vnet_subnet_id = azurerm_subnet.subnets[0].id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
    yor_trace   = "63178a4f-5a6a-4b56-aa18-5b6cc49ecc15"
    StoreStatus = "DND"
  }
}


# resource "azurerm_role_assignment" "role_acrpull" {
#   scope                            = azurerm_container_registry.acr.id
#   role_definition_name             = "AcrPull"
#   principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
#   skip_service_principal_aad_check = true
# }
