locals {
  name = {
    resource_group = "rg_KSdeployment"
    acr            = "demoacr17"
    aks            = "demoaks17"
  }
  location = "westus2"
  dns      = "dns-aks"
  node_rg  = "demo-aks-nodes"
}

resource "azurerm_resource_group" "rg" {
  name     = local.name.resource_group
  location = local.location
}

resource "azurerm_container_registry" "acr" {
  name                = local.name.acr
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  sku                 = "standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.name.aks
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  dns_prefix          = local.dns
  node_resource_group = local.node_rg

  default_node_pool {
    name       = "systempool"
    node_count = 2
    vm_size    = "Standard_B2pls_v2"
    auto_scaling_enabled = true
    max_count = 2
    min_count = 2
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Acrpull"
  scope                = azurerm_container_registry.acr.id
  depends_on = [ azurerm_kubernetes_cluster.aks ]
}