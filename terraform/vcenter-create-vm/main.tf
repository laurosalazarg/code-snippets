
provider "vsphere" {
  user           = "${var.vuser}"
  password       = "${var.vpasswd}"
  vsphere_server = "${var.vcenterInstance}" 
  allow_unverified_ssl = true
  version = "< 1.16.0"
}  


module "web01" {
  vmname                 = ""
  windomain              = ""
  domain_admin_user      = "${var.vcenteruser}"
  domain_admin_password  = "${var.vcenterpwd}"
  local_adminpass        = "${var.vmadminpwd}"
  productkey             = ""
  annotation             = ""
  orgname                = ""
  source                 = "./vmware-modules"
  vmrp                   = ""
  dc                     = ""
  vmfolder               = ""
  ds_cluster              = ""  
  vmtemp                 = ""
  instances              = 1
  cpu_number             = 4
  ram_size               = 8192
  cpu_hot_add_enabled    = "false"
  cpu_hot_remove_enabled = "false"
  memory_hot_add_enabled = "false"
  ipv4submask            = ["24"]
  network_cards          = ["${var.vnetworkname}"]
  ipv4 = { 
    "${var.vnetworkname}" = [""]
  }
  vmgateway              = ""
  vmdns                  = ["", ""]
  data_disk_size_gb      = [""]
  thin_provisioned  = ["true"]
  enable_disk_uuid = "true"
  auto_logon       = "true"
  auto_logon_count = 3
  is_windows_image = "true"
  firmware         = "bios"
  timeout = 180000
  time_zone = 20 
}


module "web02" {
  vmname                 = ""
  windomain              = ""
  domain_admin_user      = "${var.vcenteruser}"
  domain_admin_password  = "${var.vcenterpwd}"
  local_adminpass        = "${var.vmadminpwd}"
  productkey             = ""
  annotation             = ""
  orgname                = ""
  source                 = "./vmware-modules"
  vmrp                   = ""
  dc                     = ""
  vmfolder               = ""
  ds_cluster              = ""  
  vmtemp                 = ""
  instances              = 1
  cpu_number             = 4
  ram_size               = 8192
  cpu_hot_add_enabled    = "false"
  cpu_hot_remove_enabled = "false"
  memory_hot_add_enabled = "false"
  ipv4submask            = ["24"]
  network_cards          = ["${var.vnetworkname}"]
  ipv4 = { 
    "${var.vnetworkname}" = [""]
  }
  vmgateway              = ""
  vmdns                  = ["", ""]
  data_disk_size_gb      = [""]
  thin_provisioned  = ["true"]
  enable_disk_uuid = "true"
  auto_logon       = "true"
  auto_logon_count = 3
  is_windows_image = "true"
  firmware         = "bios"
  timeout = 180000
  time_zone = 20 
}