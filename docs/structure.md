Repository structure and how this repo follows Terraform module best practices (based on AWS prescriptive guidance)

Root layout:
- README.md                : module overview and quick start
- CHANGELOG.md             : release notes and changelog (keep updated)
- CONTRIBUTING.md          : contribution and development guidelines
- modules/                 : reusable module(s) (modules/proxmox-bgp)
- examples/                : example usage of the module (examples/simple)
- tests/                   : integration/test plans (terraform validate/test stubs)
- .github/workflows/       : CI for fmt/validate and release
- Makefile                 : common development tasks (fmt, init, validate, package)

Guiding principles applied:
- Keep provider configuration in examples/root module; modules are provider-agnostic.
- Provide clear examples and recommended tfvars (no secrets).
- CI validates formatting and basic syntax; full integration tests require credentials.
- Use semantic versioning and automated releases on merge to main.

See CONTRIBUTING.md for developer workflows and release process.