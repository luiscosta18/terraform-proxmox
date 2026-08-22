<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15 |
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
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional VM tags | `map(string)` | `{}` | no |
| <a name="input_vm"></a> [vm](#input\_vm) | n/a | <pre>object({<br/>    name      = string<br/>    node_name = string<br/>    vmid      = number<br/><br/>    machine = string<br/>    bios    = string<br/>    os_type = optional(string, "l26")<br/><br/>    agent_enabled = bool<br/><br/>    protection = optional(bool, false)<br/><br/>    cores  = number<br/>    memory = number<br/><br/>    storage            = string<br/>    image_datastore_id = string<br/>    image_url          = string<br/>    disk_gb            = number<br/><br/>    user     = string<br/>    password = string<br/><br/>    cloud_init = object({<br/>      enabled      = bool<br/>      datastore_id = string<br/>    })<br/><br/>    networks = list(object({<br/>      bridge      = string<br/>      model       = optional(string, "virtio")<br/>      mac_address = optional(string)<br/>      vlan_id     = optional(number)<br/>    }))<br/><br/>    tags = optional(map(string), {})<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->