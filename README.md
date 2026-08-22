# Proxmox BPG VM Module

Terraform module for creating Proxmox VMs using the
`bpg/proxmox` provider.

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

## Resources

| Name | Type |
| ---- | ---- |
| [proxmox_download_file.cloud_image](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/download_file) | resource |
| [proxmox_virtual_environment_file.cloud_init](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_vm"></a> [vm](#input\_vm) | Proxmox VM configuration | `object({...})` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional VM tags | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
