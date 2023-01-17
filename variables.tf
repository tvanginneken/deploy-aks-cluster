variable "location" {
  type    = string
  default = "West Europe"
}

variable "rg_name" {
  type    = string
  default = "smelotte-rg-002"
}
variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = "smelotte-vnet-001"
}
variable "vnet_cidr" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}
variable "subnet_cidr" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["aks", "vm"]
}
variable "dns_prefix" {
  type        = string
  description = "Name for the DNS Prefix"
}
variable "acr_name" {
  type        = string
  description = "Name of the ACR"
}
variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS Cluster"
}
variable "aks_cluster_size" {
  type        = string
  description = "Size of VM into AKS Cluster"
  default     = "value"
}
variable "aks_cluster_count" {
  type        = number
  description = "Number of node into AKS Cluster"
  default     = 1
}


# NGINX VM
variable "nginx_vm_required" {
  default = false
}
variable "nginx_vm_size" {
  type        = string
  description = "Size (SKU) of the virtual machine to create"
}
variable "nginx_admin_username" {
  description = "Username for Virtual Machine administrator account"
  type        = string
  default     = ""
}
variable "nginx_admin_password" {
  description = "Password for Virtual Machine administrator account"
  type        = string
  default     = ""
}
variable "publisher" {
  type        = string
  description = "Publisher ID for CentOS Linux"
  default     = "OpenLogic"
}
variable "offer" {
  type        = string
  description = "Offer ID for CentOS Linux"
  default     = "CentOS"
}
variable "sku" {
  type        = string
  description = "SKU ID for CentOS Linux"
  default     = "8_4-gen2"
}
