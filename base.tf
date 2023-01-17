
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags = {
    yor_trace   = "25e4d805-00d0-4dc0-93b8-fa566a2a956f"
    StoreStatus = "DND"
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_cidr
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    yor_trace   = "7b7e1949-6ac6-4a12-ad27-a62d8b5ed1c8"
    StoreStatus = "DND"
  }

}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr[count.index]]
}

# Create Network Security Group
resource "azurerm_network_security_group" "nginx-vm-nsg" {
  count               = var.nginx_vm_required ? 1 : 0
  depends_on          = [azurerm_resource_group.rg]
  name                = "nginx-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "Allow-SSH"
    description                = "Allow SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    description                = "Allow HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Prisma-Cloud"
    description                = "Allow Prisma Cloud"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8083"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  tags = {
    yor_trace   = "26a044af-4348-41ba-8409-bae45ca05520"
    owner       = "smelotte"
    StoreStatus = "DND"
  }
}


# Associate the web NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "nginx-vm-nsg-association" {
  count                     = var.nginx_vm_required ? 1 : 0
  depends_on                = [azurerm_resource_group.rg, azurerm_subnet.subnets, azurerm_network_interface.nginx-nic]
  subnet_id                 = azurerm_subnet.subnets[1].id
  network_security_group_id = azurerm_network_security_group.nginx-vm-nsg[0].id
}
