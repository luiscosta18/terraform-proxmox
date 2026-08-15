# terraform-proxmox

This repository provides a Terraform module scaffold to manage BGP configuration on Proxmox hosts using the bpg/proxmox provider.

Structure:

- modules/proxmox-bgp - The reusable module
- examples/simple - Example of using the module
- .github/workflows/release.yml - GitHub Action to create a release on push to main

Usage:
1. Add provider configuration in the root module and supply credentials via environment variables or a credentials file.
2. Call the module and provide `bgp_peers` and `tags`.

Security:
- Avoid checking secrets into source control. Use environment variables, Vault, or GitHub Secrets for CI.

Contributing:
- Follow semantic versioning. Each merge to `main` will create a release automatically (see CI workflow).
