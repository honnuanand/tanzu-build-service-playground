###########################
## Providers 
###########################
provider "azurerm" {
  version         = ">= 2.0"
  features {}
}
###########################
## Variables
###########################
variable "resource-group-name" {

}


###########################
## Data Sources 
###########################


###########################
## Resources 
###########################
resource "azurerm_resource_group" "${var.resource_group_name}" {
  name     = "tbs-resource-grp"
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "tbs-cluster" {
  name                = "tbs-cluster"
  location            = azurerm_resource_group.tbs-resource-grp.location
  resource_group_name = azurerm_resource_group.tbs-resource-grp.name
  dns_prefix          = "tbs"

  default_node_pool {
    name       = "tbs"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Demo" # can have dev / stage / prod 
  }
}

###########################
## OUTPUTS
###########################

output "client_certificate" {
  value = azurerm_kubernetes_cluster.tbs-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.tbs-cluster.kube_config_raw
}