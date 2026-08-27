<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.16.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.111 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | ~> 0.11.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_talos"></a> [talos](#module\_talos) | ../../modules/talos | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_proxmox_api_token"></a> [proxmox\_api\_token](#input\_proxmox\_api\_token) | Proxmox API token. | `string` | n/a | yes |
| <a name="input_proxmox_endpoint"></a> [proxmox\_endpoint](#input\_proxmox\_endpoint) | Proxmox endpoint URL. | `string` | n/a | yes |
| <a name="input_talos_iso_checksum"></a> [talos\_iso\_checksum](#input\_talos\_iso\_checksum) | Optional SHA-512 checksum of the Talos ISO. | `string` | `null` | no |
| <a name="input_talos_iso_url"></a> [talos\_iso\_url](#input\_talos\_iso\_url) | Talos Image Factory ISO URL. | `string` | n/a | yes |
| <a name="input_talos_schematic_id"></a> [talos\_schematic\_id](#input\_talos\_schematic\_id) | Talos Image Factory schematic ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubernetes kubeconfig |
| <a name="output_talosconfig"></a> [talosconfig](#output\_talosconfig) | Talos client configuration |
<!-- END_TF_DOCS -->
