###########################
## Resources 
###########################

resource "azurerm_container_registry" "acr" {
  name                     = var.registry_name
  resource_group_name      = var.resource_grp_name
  location                 = "westus2"#azurerm_resource_group.resource_grp.location
  sku                      = "Premium"
  admin_enabled            = true
  georeplication_locations = ["East US", "West Europe"]
}

