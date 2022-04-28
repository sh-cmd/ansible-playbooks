resource "azurerm_public_ip" "vm" {
  name                         = "${var.pub_ip_name}-publicIP"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg_name}"
  allocation_method            = "${var.ip_allocation_method}"
}
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm.id
  }
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
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "azureuser"
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