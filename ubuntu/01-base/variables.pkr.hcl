variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "vm_name_prefix" {
  type = string
}

variable "is_workstation" {
  type = bool
  default = false
}

variable "boot_wait" {
  type = string
  default = "5s"
}

variable "boot_command" {
  type = list(string)
}

variable "headless" {
  type = bool
  default = true
}

variable "hyperv_switch_name" {
  type = string
  default = "LAN"
}

locals {
  vm_name = "${var.vm_name_prefix}_base"
  project_directory = replace(path.root, "/ubuntu/01-base", "")
  hyperv_http_directory = "${path.root}/http/${var.vm_name_prefix}/hyperv"
  hyperv_output_directory = "${path.root}/output/${var.vm_name_prefix}/hyperv"
  qemu_http_directory = "${path.root}/http/${var.vm_name_prefix}/qemu"
  qemu_output_directory = "${path.root}/output/${var.vm_name_prefix}/qemu"
}
