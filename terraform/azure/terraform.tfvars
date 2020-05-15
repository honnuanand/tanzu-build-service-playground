###########################
##  Values for Variables
###########################

## Generic Vars 
resource_grp_name   = "tbs-rg"

## Cluster variables 
cluster_name        = "tbs-cluster"
dns_prefix          = "tbs"
nodepool_name       = "tbsnp" # special characters not allowed 
vm_size             = "Standard_D2_v2"
environment_name    = "demo" # can have dev / stage / prod  

## Acr variables 
# registry_name       = "araotbs01"