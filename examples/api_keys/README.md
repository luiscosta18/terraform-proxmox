# Proxmox VM management API key

This example creates a Proxmox API token, creates a group, creates a custom
role, and assigns that role to the group at `/`. The role allows the token
owner to manage VM lifecycle, disks, and VM configuration properties.

The token user must already exist and must already be a member of the group.
The module does not manage user membership. Because the example uses
`privileges_separation = false`, use a dedicated Proxmox user with no other
privileges; the token inherits that user's permissions.

The provider is pinned to `bpg/proxmox` `~> 0.112.0`.

```bash
terraform init
terraform apply
terraform output -raw api_key_value
```

The token value is only returned when the token is created. Store it securely
and pass it to VM-management Terraform configurations as:

```text
terraform@pve!terraform-vm-management=<token-value>
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.16 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.113 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_api_key"></a> [api\_key](#module\_api\_key) | ../../modules/api_keys | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_api_key_group_id"></a> [api\_key\_group\_id](#input\_api\_key\_group\_id) | Group receiving VM management permissions. | `string` | `"terraform-vm-management"` | no |
| <a name="input_api_key_token_name"></a> [api\_key\_token\_name](#input\_api\_key\_token\_name) | Name of the API token to create. | `string` | `"terraform-vm-management"` | no |
| <a name="input_api_key_user_id"></a> [api\_key\_user\_id](#input\_api\_key\_user\_id) | Existing Proxmox user ID. The user must already be a member of api\_key\_group\_id. | `string` | `"terraform@pve"` | no |
| <a name="input_proxmox_api_token"></a> [proxmox\_api\_token](#input\_proxmox\_api\_token) | Existing administrative API token used to create the new token and ACL. | `string` | n/a | yes |
| <a name="input_proxmox_endpoint"></a> [proxmox\_endpoint](#input\_proxmox\_endpoint) | Proxmox API endpoint URL. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_key_id"></a> [api\_key\_id](#output\_api\_key\_id) | The created Proxmox API token ID. |
| <a name="output_api_key_value"></a> [api\_key\_value](#output\_api\_key\_value) | The created Proxmox API token value. Save it immediately; Proxmox does not show it again. |
<!-- END_TF_DOCS -->