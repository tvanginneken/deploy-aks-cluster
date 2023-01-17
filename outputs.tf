output "nginx_vm_name" {
  description = "Virtual Machine name"
  value       = var.nginx_vm_required ? azurerm_linux_virtual_machine.nginx-vm[0].name : null
}

output "nginx_vm_ip_address" {
  description = "Virtual Machine IP Address"
  value       = var.nginx_vm_required ? azurerm_public_ip.nginx-vm-ip[0].ip_address : null
}

output "nginx_vm_admin_username" {
  description = "Administrator Username for the Virtual Machine"
  value       = var.nginx_vm_required ? var.nginx_admin_username : null
  sensitive   = true
}

output "nginx_vm_admin_password" {
  description = "Administrator Password for the Virtual Machine"
  value       = var.nginx_vm_required ? random_password.nginx-vm-password.result : null
  sensitive   = true
}
