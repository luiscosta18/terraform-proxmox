<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.111 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.111 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [proxmox_download_file.cloud_image](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/download_file) | resource |
| [proxmox_virtual_environment_file.cloud_init](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_vm"></a> [vm](#input\_vm) | Proxmox virtual machine configuration. | <pre>object({<br/>    name        = string<br/>    description = optional(string, "Managed by Terraform")<br/><br/>    node_name = string<br/>    vmid      = optional(number)<br/><br/>    machine = optional(string, "q35")<br/>    bios    = optional(string, "seabios")<br/><br/>    operating_system_type = optional(string, "l26")<br/><br/>    on_boot    = optional(bool, true)<br/>    started    = optional(bool, true)<br/>    protection = optional(bool, false)<br/>    acpi       = optional(bool, true)<br/><br/>    agent_enabled = optional(bool, true)<br/><br/>    cpu = optional(object({<br/>      cores   = optional(number, 2)<br/>      sockets = optional(number, 1)<br/>    }), {})<br/><br/>    memory = optional(number, 4096)<br/><br/>    image = object({<br/>      datastore_id       = string<br/>      url                = string<br/>      checksum           = optional(string)<br/>      checksum_algorithm = optional(string)<br/>    })<br/><br/>    disk = object({<br/>      datastore_id = string<br/>      size         = optional(number, 32)<br/>    })<br/><br/>    networks = list(object({<br/>      bridge      = string<br/>      model       = optional(string, "virtio")<br/>      mac_address = optional(string)<br/>      vlan_id     = optional(number)<br/><br/>      ipv4 = object({<br/>        address = string<br/>        gateway = optional(string)<br/>      })<br/><br/>      ipv6 = optional(object({<br/>        address = string<br/>        gateway = string<br/>      }))<br/>    }))<br/><br/>    cloud_init = object({<br/>      enabled              = optional(bool, true)<br/>      datastore_id         = string<br/>      snippet_datastore_id = string<br/><br/>      user     = string<br/>      ssh_keys = list(string)<br/>    })<br/><br/>    tags = optional(map(string), {})<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->