Contribution guide — terraform-proxmox module

Goals
- Maintain a small, testable module that follows Terraform module best practices.
- Keep provider configuration out of modules; provide examples that configure providers.
- Ensure CI checks formatting and validation on PRs.

Development workflow
1. Fork or branch from main.
2. Implement changes in modules/ or examples/ with small focused commits.
3. Update README and CHANGELOG for user-facing changes.
4. Run `make fmt` and `make validate` locally before opening a PR.

Repository conventions
- Modules must be idempotent and provider-agnostic.
- No secrets in the repo. Use environment variables or CI secrets for credentials.
- Examples live under examples/* and must demonstrate minimum viable configuration.

Testing & CI
- CI will run terraform fmt and validate on PRs and pushes to main.
- Integration tests that require access to a Proxmox instance should be run manually or in a secure CI with credentials.

Releases
- Use semantic versioning. Merges to main will trigger the release workflow which creates a release tag and artifact.
- Update CHANGELOG.md with notable changes before merging.

Contact
- Open issues and PRs for questions or improvements.
