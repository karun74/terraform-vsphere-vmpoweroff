variable "vsphere_user" {
  type="string"
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  default="P@ssw0rd!"
  type="string"
}
variable "vsphere_server" {
  default="vcsa.dell.local"
}
variable "vm_name" {
  type="string"
  default="terraform-test"
}
variable "vm_ip" {
 type="string"
  default="192.168.1.245"
}
variable vm_ip4_gateway{
type="string"
  default="192.168.1.254"
}
variable vm_template_name{
  type="string"
  default="photon-template"
}

