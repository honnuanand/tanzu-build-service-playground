###########################
## Resources 
###########################

resource "azurerm_container_registry" "acr" {
  name                     = var.registry_name
  resource_group_name      = azurerm_resource_group.resource_grp.name
  location                 = azurerm_resource_group.resource_grp.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}