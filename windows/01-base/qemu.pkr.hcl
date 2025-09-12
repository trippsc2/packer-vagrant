packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "qemu" {
  vm_name = local.vm_name
  headless = var.headless
  display = "none"
  efi_boot = true
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE.secboot.fd"
  use_pflash = true
  machine_type = "q35"

  qemuargs = [
    ["-cpu", "host,arch_capabilities=off"]
  ]

  cores = 4
  memory = 8192

  disk_size = "81920"
  disk_discard = "unmap"
  format = "qcow2"

  iso_url = var.iso_url
  iso_checksum = var.iso_checksum

  cd_files = [
    "${path.root}/cd/common/*",
    "${path.root}/cd/qemu/*",
    "${path.root}/cd/${var.vm_name_prefix}/qemu/*"
  ]

  boot_wait = var.boot_wait
  boot_command = [
    "<enter><wait><enter><wait><enter><wait><enter>"
  ]

  communicator = "winrm"
  winrm_username = "Administrator"
  winrm_password = "Packer42-"
  winrm_timeout = "1h"
  winrm_use_ssl = false

  shutdown_command = "shutdown /s /t 10 /f"
  shutdown_timeout = "10m"

  output_directory = local.qemu_output_directory
}
