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
