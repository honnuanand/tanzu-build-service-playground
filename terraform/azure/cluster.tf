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
variable "resource_grp_name" {
  default = "tbs-rg"
}
variable "cluster_name" {
  default = "tbs-cluster"
}
variable "dns_prefix" {
  default = "tbs"
}
variable "nodepool_name" {
  default = "tbsnp" # special characters not allowed 
}

variable "vm_size" {
  default = "Standard_D2_v2"
}
variable "environment_name" {
  default = "demo" # can have dev / stage / prod 
}


###########################
## Data Sources 
###########################


###########################
## Resources 
###########################
resource "azurerm_resource_group" "resource_grp_name" {
  name     = var.resource_grp_name
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "tbs_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.resource_grp_name.location
  resource_group_name = azurerm_resource_group.resource_grp_name.name
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

###########################
## OUTPUTS
###########################

output "client_certificate" {
  value = azurerm_kubernetes_cluster.tbs_cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.tbs_cluster.kube_config_raw
}