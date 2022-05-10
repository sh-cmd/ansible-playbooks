module "vnet" {
    source = "./modules/vnet"
    vnet_name = var.vnet_name
    rg_name = var.rg_name
    location = var.location
    subnet_name = var.subnet_name
    cidr_vnet = var.cidr_vnet
    cidr_subnet = var.cidr_subnet
  
}

module "ansible_master_vnet" {
    source = "./modules/vnet"
    vnet_name = var.ansible_master_vnet_name
    rg_name = var.ansible_master_rg_name
    location = var.ansible_master_location
    subnet_name = var.ansible_master_subnet_name
    cidr_vnet = var.ansible_master_cidr_vnet
    cidr_subnet = var.ansible_master_cidr_subnet
}

module "ansible-master"{
  depends_on = [
    module.ansible_master_vnet
  ]
  source  = "./modules/ansible_master"
  rg_name =   "${var.ansible_master_rg_name}"
  location = var.ansible_master_location
  subnet_id = module.ansible_master_vnet.subnet_id
  vm_name = "${var.vm_name}-ansible-master"
  vm_size    = var.vm_size_ansible_master
  ip_allocation_method = var.ip_allocation_method
  pub_ip_name = "${var.pub_ip_name}-ansible-master"
  os_disk_name = "${var.os_disk_name}-ansible-master"
  computer_name = "${var.computer_name}-ansible-master"
  private_ip_address = var.private_ip_address_ansible_master
}

resource "azurerm_virtual_machine_extension" "test" {
  name                 = "hostname"
  virtual_machine_id =  module.ansible-master.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
     "commandToExecute": "ssh-keygen -t rsa -f ~/.ssh/id_rsa <<< y"
  }
SETTINGS

}
 module "virtual-machine-master" {
  depends_on = [
    module.vnet
  ]
  source  = "./modules/vms"
  rg_name =   "${var.rg_name}"
  location = var.location
  subnet_id = module.vnet.subnet_id
  vm_name = "${var.vm_name}-master"
  vm_size    = var.vm_size_master
  ip_allocation_method = var.ip_allocation_method
  pub_ip_name = "${var.pub_ip_name}-master"
  os_disk_name = "${var.os_disk_name}-master"
  computer_name = "${var.computer_name}-master"
  private_ip_address = var.private_ip_address_master
}

module "virtual-machine-node" {
  depends_on = [
    module.vnet
  ]
  source  = "./modules/vms"
  count = "${var.node_count}"
  rg_name =   "${var.rg_name}"
  location = "${var.location}"
  subnet_id = module.vnet.subnet_id
  vm_name = "${var.vm_name}-${count.index}-node"
  vm_size    = "${var.vm_size_node}"
  ip_allocation_method = "${var.ip_allocation_method}"
  pub_ip_name = "${var.pub_ip_name}-${count.index}-node"
  os_disk_name = "${var.os_disk_name}-${count.index}-node"
  computer_name = "${var.computer_name}-${count.index}-node"
  private_ip_address = "${format("10.0.%03d.6", count.index + 1)}"

}

resource "local_file" "hosts_cfg" {
  content = templatefile("inventory_template",
    { 
      master_ip_addrs = module.virtual-machine-master.public_ip
      ip_addrs = module.virtual-machine-node.*.public_ip
    }
  )
  filename = "inventory"
}

