output "public_ip" {
    value = azurerm_public_ip.vm.ip_address
}
output "private_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

output "vm_id" {
  value = azurerm_virtual_machine.main.id 
}

output "azurerm_public_ip" {
  value = azurerm_public_ip.vm.ip_address
}