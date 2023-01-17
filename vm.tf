# Bootstrapping Template File
data "template_file" "nginx-vm-cloud-init" {
  template = file("install-nginx.sh")
}

# Generate random password
resource "random_password" "nginx-vm-password" {
  length           = 20
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

# Generate a random vm name
resource "random_string" "nginx-osdisk-name" {
  length  = 5
  upper   = false
  numeric = false
  lower   = true
  special = false
}
# Get a Static Public IP
resource "azurerm_public_ip" "nginx-vm-ip" {
  count               = var.nginx_vm_required ? 1 : 0
  depends_on          = [azurerm_resource_group.rg]
  name                = "nginx-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags = {
    yor_trace   = "697e2aaf-97d7-42a7-a8d7-7d348b5cc02b"
    StoreStatus = "DND"
  }
}

# Create Network Card for the VM
resource "azurerm_network_interface" "nginx-nic" {
  count               = var.nginx_vm_required ? 1 : 0
  depends_on          = [azurerm_resource_group.rg, azurerm_subnet.subnets]
  name                = "nginx-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[1].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nginx-vm-ip[0].id
  }
  tags = {
    yor_trace   = "cd83ccb8-6565-4b32-955a-d1c1511c7648"
    StoreStatus = "DND"
  }
}
# Create Nginx VM
resource "azurerm_linux_virtual_machine" "nginx-vm" {
  count                 = var.nginx_vm_required ? 1 : 0
  depends_on            = [azurerm_network_interface.nginx-nic]
  name                  = "nginx-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nginx-nic[0].id]
  size                  = var.nginx_vm_size
  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
  os_disk {
    name                 = format("nginx-%s", random_string.nginx-osdisk-name.result)
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "nginx-vm"
  admin_username                  = var.nginx_admin_username
  admin_password                  = random_password.nginx-vm-password.result
  disable_password_authentication = false
  custom_data                     = base64encode(data.template_file.nginx-vm-cloud-init.rendered)
  tags = {
    yor_trace   = "6f1c5e20-c131-4d7c-b4e9-95bf4a1e2ff0"
    StoreStatus = "DND"
  }
}

