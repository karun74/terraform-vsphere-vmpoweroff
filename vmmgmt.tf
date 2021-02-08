data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "vsanDatastore"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "AZ1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "mgmt"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}



data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name 
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

}

provision "remote-exec" {
    inline = [ "systemctl shutdown"]
    on_failure = "continue"
    connection {
       host = "${data.vsphere_virtual_machine.vm.default_ip_address}"
       type = "ssh"
       user = var.vm_user
       password = var.vsphere_vm_password
    }
}

    
