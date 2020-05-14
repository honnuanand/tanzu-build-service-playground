###########################
## Resources 
###########################

resource "local_file" "kubeconfig" {
    content     = azurerm_kubernetes_cluster.tbs_cluster.kube_config_raw
    filename = "azk8s"  #${path.module}/foo.bar"
}