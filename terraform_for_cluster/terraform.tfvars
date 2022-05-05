rg_name = "kubernetes_cluster"
location = "southcentralus"
vnet_name = "kubernetes_vnet"
cidr_vnet = "10.0.0.0/16"
subnet_name = "kubernetes_subnet"
cidr_subnet = "10.0.0.0/16"
vm_size_master = "Standard_B2s"
vm_size_node = "Standard_B2s"
vm_name = "vm-linux"
pub_ip_name = "vm-linux"
ip_allocation_method = "Static"
os_disk_name = "giitosdisk"
node_count = 1
computer_name = "azureuser"
private_ip_address_master = "10.0.0.5"

ansible_master_rg_name = "ansible-master"
ansible_master_location = "eastus"
ansible_master_vnet_name = "ansibe-vnet"
ansible_master_cidr_vnet = "10.1.0.0/16"
ansible_master_subnet_name = "ansible-subnet"
ansible_master_cidr_subnet = "10.1.0.0/16"
vm_size_ansible_master = "Standard_B2s"
private_ip_address_ansible_master = "10.1.0.5"



