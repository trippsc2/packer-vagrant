packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.3"
      source = "github.com/hashicorp/ansible"
    }

    vagrant = {
      version = ">= 1.1.5"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  sources = [
    "source.qemu.qemu",
    "source.hyperv-vmcx.hyperv"
  ]

  provisioner "ansible" {
    playbook_file = "${local.project_directory}/ansible/debian_seal_for_template.yml"
    use_proxy = false
    
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_NOCOLOR=True"
    ]

    ansible_ssh_extra_args = [
      "-o IdentitiesOnly=yes",
      "-o StrictHostKeyChecking=no",
      "-o UserKnownHostsFile=/dev/null"
    ]

    extra_arguments = [
      "-e",
      "target_hostname=${local.hostname} ansible_password=vagrant",
      "--scp-extra-args",
      "'-O'"
    ]
  }

  post-processors {
    post-processor "vagrant" {
      vagrantfile_template = "${path.root}/Vagrantfile"
      output = "${path.root}/${local.vm_name}_{{.BuildName}}_{{.Provider}}_{{.Architecture}}.box"
    }

    post-processor "vagrant-registry" {
      client_id = var.vagrant_hcp_client_id
      client_secret = var.vagrant_hcp_client_secret
      box_tag = local.box_tag
      version = local.box_version
      keep_input_artifact = true
      no_direct_upload = true
    }
  }
}
