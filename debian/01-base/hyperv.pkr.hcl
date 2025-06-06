packer {
  required_plugins {
    hyperv = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/hyperv"
    }
  }
}

source "hyperv-iso" "hyperv" {
  vm_name = local.vm_name
  headless = var.headless
  configuration_version = "9.0"
  generation = 2

  http_directory = local.hyperv_http_directory
  http_port_min = 8872
  http_port_max = 8872

  cpus = 2
  memory = 2048

  switch_name = var.hyperv_switch_name

  disk_size = "40960"

  iso_url = var.iso_url
  iso_checksum = var.iso_checksum

  boot_wait = "12s"
  boot_command = [
    "<down>e",
    "<down><down><down><end>priority=critical net.ifnames=0 biosdevname=0 auto=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    "<leftCtrlOn>x<leftCtrlOff>"
  ]

  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout = "60m"

  shutdown_command = "sudo -S /sbin/halt -h -p"

  output_directory = local.hyperv_output_directory
}
