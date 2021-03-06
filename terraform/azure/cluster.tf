###########################
## Providers 
###########################
provider "azurerm" {
  version         = ">= 2.0"
  features {}
}


###########################
## Data Sources 
###########################


###########################
## Resources 
###########################
resource "azurerm_resource_group" "resource_grp" {
  name     = var.resource_grp_name
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "tbs_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.resource_grp.location
  resource_group_name = azurerm_resource_group.resource_grp.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.nodepool_name
    node_count = 3
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment_name 
  }

}










