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
5. Use Conventional Commit messages for user-facing changes; release notes are generated from them.
6. Run the required checks locally before opening a PR.

## Commit Messages and Releases

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages. Releases are generated from commits merged into `main`:

- `feat:` starts a minor release.
- `fix:` starts a patch release.
- Add `!` after the type or scope for a breaking change, such as `feat!: remove an input`, to start a major release.
- Other commit types do not trigger a release by themselves.

Merging a releasable Conventional Commit into `main` publishes a semantic release and module ZIP directly. Existing date-based releases are retained, and the SemVer series now continues from `v1.0.0`. Breaking changes take precedence over features, and features take precedence over fixes when several releasable commits are included in one push.
