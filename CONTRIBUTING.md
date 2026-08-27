# Contributing

Contribution guide for the `terraform-proxmox` project.

## Goals

- Keep modules small, reusable, and testable.
- Follow Terraform module best practices.
- Keep provider configuration outside reusable modules.
- Keep resources configurable through module inputs.
- Maintain clear documentation and examples.
- Ensure CI passes before merging changes.

## Development Workflow

1. Fork the repository or create a branch from `main`.
2. Make focused changes under `modules/` or `examples/`.
3. Keep commits small and descriptive.
4. Update documentation when changing module behavior.
5. Update `CHANGELOG.md` for user-facing changes.
6. Run the required checks locally before opening a PR.
