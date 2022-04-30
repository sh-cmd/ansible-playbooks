rg_name = "kubernetes_cluster"
location = "southcentralus"
vnet_name = "test_vnet"
cidr_vnet = "10.0.0.0/16"
subnet_name = "test_subnet"
cidr_subnet = "10.0.0.0/22"
vm_size_master = "Standard_B2s"
vm_size_node = "Standard_B1s"
vm_name = "vm-linux"
pub_ip_name = "vm-linux"
ip_allocation_method = "Static"
os_disk_name = "giitosdisk"
node_count = 2
computer_name = "azureuser"
private_ip_address_master = "10.0.0.5"