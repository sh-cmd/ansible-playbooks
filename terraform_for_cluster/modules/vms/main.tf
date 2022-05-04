resource "azurerm_public_ip" "vm" {
  name                         = "${var.pub_ip_name}-publicIP"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg_name}"
  allocation_method            = "${var.ip_allocation_method}"
}
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
}
resource "azurerm_network_security_rule" "all" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "ssh" {
  name                        = "all"
  priority                    = 118
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "rule1" {
  name                        = "rule1"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10250"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "rule2" {
  name                        = "rule2"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10251"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "rule3" {
  name                        = "rule3"
  priority                    = 107
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10252"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "rule4" {
  name                        = "rule4"
  priority                    = 108
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "rule5" {
  name                        = "rule5"
  priority                    = 109
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "2379-2380"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "https" {
  name                        = "https"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Static"
    private_ip_address = var.private_ip_address
    public_ip_address_id = azurerm_public_ip.vm.id
  }
}
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vm_name}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.rg_name}"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "${var.vm_size}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.computer_name}"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        key_data = file("~/.ssh/id_rsa.pub")
        path = "/home/azureuser/.ssh/authorized_keys"
    }
  }
  
  
  tags = {
    ProjectName  = "demo-project"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

resource "azurerm_managed_disk" "disk" {
  name                 = "${var.vm_name}"
  location             = "${var.location}"
  resource_group_name  = "${var.rg_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadWrite"
}