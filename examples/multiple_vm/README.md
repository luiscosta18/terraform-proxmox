<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.16.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.113 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_vm"></a> [vm](#module\_vm) | ../../modules/vm | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_proxmox_api_token"></a> [proxmox\_api\_token](#input\_proxmox\_api\_token) | Proxmox API token. | `string` | n/a | yes |
| <a name="input_proxmox_endpoint"></a> [proxmox\_endpoint](#input\_proxmox\_endpoint) | Proxmox endpoint URL. | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key to provision on the VM. | `string` | n/a | yes |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | Number of Ubuntu VMs to create. | `number` | `2` | no |
| <a name="input_vm_name_prefix"></a> [vm\_name\_prefix](#input\_vm\_name\_prefix) | Prefix used for VM names. | `string` | `"ubuntu"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->