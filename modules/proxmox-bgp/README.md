# terraform-proxmox/modules/proxmox-bgp

Terraform module scaffold to manage BGP configuration on Proxmox hosts.

This module is intentionally provider-agnostic inside (does not configure providers) so the calling root module supplies provider configuration and credentials.

## Features
- Accepts a list of BGP peers to configure
- Supports a tags map applied to resources
- Example placeholders show where to map to real provider resources

## Usage

```hcl
module "proxmox_bgp" {
  source = "../modules/proxmox-bgp"

  bgp_enabled = true
  bgp_peers = [
    {
      name = "peer-1"
      remote_as = 65001
      remote_addr = "192.0.2.1"
      description = "uplink"
      tags = { environment = "prod" }
    }
  ]

  tags = {
    project = "infrastructure"
    owner   = "netops"
  }
}
```

## Notes & Best practices
- Do not put credentials in module variables. Configure provider authentication in the root module or via environment variables.
- This module currently contains placeholder/null_resource entries so it is safe to review and adapt. When the upstream provider resource names are known (see provider docs), replace the placeholders with real resources and remove the `null_resource` scaffolding.
- Include semantic versioning and changelog for releases.

## Inputs
See variables.tf

## Outputs
See outputs.tf
