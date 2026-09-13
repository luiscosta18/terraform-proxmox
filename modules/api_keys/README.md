# Proxmox API keys

This module creates:

- a Proxmox API token for an existing user;
- a Proxmox group;
- a custom Proxmox role with the requested privileges;
- an ACL granting a role to that group.

The token uses the owner's group permissions by default. The token owner must
already exist and be a member of the created group in Proxmox. This module
does not manage user membership.

## Example

```hcl
module "automation_api_key" {
  source = "../../modules/api_keys"

  api_key = {
    user_id     = "terraform@pve"
    token_name  = "automation"
    comment     = "Terraform automation"
  }

  group = {
    group_id = "terraform-automation"
    comment  = "Terraform automation permissions"
  }

  permission = {
    path      = "/"
    propagate = true
  }

  role = {
    role_id = "terraform-vm-management"

    privileges = [
      "Datastore.AllocateSpace",
      "Datastore.Audit",
      "VM.Allocate",
      "VM.Audit",
      "VM.Clone",
      "VM.Config.CDROM",
      "VM.Config.CPU",
      "VM.Config.Disk",
      "VM.Config.HWType",
      "VM.Config.Memory",
      "VM.Config.Network",
      "VM.Config.Options",
      "VM.Console",
      "VM.GuestAgent.Audit",
      "VM.Migrate",
      "VM.PowerMgmt",
      "VM.Snapshot",
      "VM.Snapshot.Rollback",
    ]
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.16 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.113 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.113 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [proxmox_acl.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/acl) | resource |
| [proxmox_user_token.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/user_token) | resource |
| [proxmox_virtual_environment_group.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_group) | resource |
| [proxmox_virtual_environment_role.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Proxmox API token configuration. The user must already exist. | <pre>object({<br/>    user_id               = string<br/>    token_name            = string<br/>    comment               = optional(string)<br/>    expiration_date       = optional(string)<br/>    privileges_separation = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Proxmox group configuration. | <pre>object({<br/>    group_id = string<br/>    comment  = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_permission"></a> [permission](#input\_permission) | ACL path and role assignment for the group. | <pre>object({<br/>    path      = string<br/>    propagate = optional(bool, true)<br/>  })</pre> | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | Custom Proxmox role and its privileges. | <pre>object({<br/>    role_id    = string<br/>    privileges = set(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_key_id"></a> [api\_key\_id](#output\_api\_key\_id) | Proxmox API token identifier. |
| <a name="output_api_key_value"></a> [api\_key\_value](#output\_api\_key\_value) | Proxmox API token value. It is only available when the token is created. |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | Proxmox group identifier. |
| <a name="output_permission_id"></a> [permission\_id](#output\_permission\_id) | Proxmox ACL identifier. |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | Proxmox role identifier. |
<!-- END_TF_DOCS -->