module "vnet" {
    source = "./modules/vnet"
    vnet_name = var.vnet_name
    rg_name = var.rg_name
    location = var.location
    subnet_name = var.subnet_name
    cidr_vnet = var.cidr_vnet
    cidr_subnet = var.cidr_subnet
  
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
}


resource "local_file" "hosts_cfg" {
  content = templatefile("/home/shubham/Desktop/Devops_training/kubenetes_with_ansible/ansible-playbooks/terraform_for_cluster/inventory_template",
    { 
      master_ip_addrs = module.virtual-machine-master.public_ip
      ip_addrs = module.virtual-machine-node.*.public_ip
    }
  )
  filename = "inventory"
}
