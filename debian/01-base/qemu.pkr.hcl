packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "qemu" {
  vm_name = local.vm_name
  headless = true
  display = "none"
  machine_type = "q35"

  http_directory = local.qemu_http_directory

  cpu_model = "host"
  cores = 2
  memory = 2048

  disk_size = "40960"
  disk_discard = "unmap"
  format = "qcow2"

  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
 
  boot_wait = "12s"
  boot_command = [
    "<down><tab>priority=critical auto=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]
 
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout = "60m"

  shutdown_command = "sudo -S /sbin/halt -h -p"
  
  output_directory = local.qemu_output_directory
}
