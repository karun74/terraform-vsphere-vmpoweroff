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

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = var.vm_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.vm_ip4_gateway
    }
  }
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

    
