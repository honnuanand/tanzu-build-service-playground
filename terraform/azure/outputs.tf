###########################
## OUTPUTS
###########################

### aks cluster outputs
output "client_certificate" {
  value = azurerm_kubernetes_cluster.tbs_cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.tbs_cluster.kube_config_raw
}

### ACR Outputs
output "registry_url" {
  value = azurerm_container_registry.acr.login_server
}
output "registry_user" {
  value = azurerm_container_registry.acr.admin_username
}
output "registry_password" {
  value = azurerm_container_registry.acr.admin_password
}
