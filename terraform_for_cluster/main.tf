module "vnet" {
    source = "./modules/vnet"
    vnet_name = var.vnet_name
    rg_name = var.rg_name
    location = var.location
    subnet_name = var.subnet_name
    cidr_vnet = var.cidr_vnet
    cidr_subnet = var.cidr_subnet
  
}

module "virtual-machine" {
  source  = "./modules/vms"
#   version = "2.3.0"
  count = 2

  rg_name =   "${var.rg_name}"
  location             = var.location
  subnet_id = module.vnet.subnet_id
  vm_name = "${var.vm_name}-${count.index}"
  # os_flavor               = "linux"
  # linux_distribution_name = "ubuntu2004"
  vm_size    = var.vm_size
  # generate_admin_ssh_key  = true
#   instances_count         = 2
  # enable_public_ip_address         = true
  # nsg_inbound_rules = [
  #   {
  #     name                   = "ssh"
  #     destination_port_range = "22"
  #     source_address_prefix  = "*"
  #   },
  #   {
  #     name                   = "http"
  #     destination_port_range = "80"
  #     source_address_prefix  = "*"
  #   },
  #   {
  #     name                   = "https"
  #     destination_port_range = "443"
  #     source_address_prefix  = "*"
  #   },
  # ]
  # enable_boot_diagnostics = false
  # data_disks = [
  #   {
  #     name                 = "disk2"
  #     disk_size_gb         = 16
  #     storage_account_type = "Standard_LRS"
  #   }
  # ]
}