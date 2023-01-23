####################
# Common Variables #
####################
location = "westeurope"
rg_name  = "replaceme-rg-001"

####################
# VNET Variables   #
# RESERVED Service CIDR 10.0.0.0/16
####################
vnet_name    = "replaceme-vnet-001"
vnet_cidr    = ["10.0.0.0/8"]
subnet_names = ["aks", "vm"]
subnet_cidr  = ["10.240.0.0/16", "10.1.0.0/24"]


####################
# AKS Variables    #
####################
dns_prefix        = "replacemeaks"
acr_name          = "replacemeacr"
aks_cluster_name  = "replaceme-aks-001"
aks_cluster_size  = "Standard_B4ms"
aks_cluster_count = 1

############
# nginx VM #
############
nginx_vm_required    = false
nginx_vm_size        = "Standard_B2s"
nginx_admin_username = "tfadmin"
publisher            = "OpenLogic"
offer                = "CentOS"
sku                  = "8_4-gen2"

