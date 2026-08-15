Tests and verification

This folder contains guidance and stubs for testing the module. Integration tests require a reachable Proxmox endpoint and credentials. For safe CI, run integration tests only in protected pipelines with secrets.

Suggested tests:
- terraform init & validate using examples/simple
- Create/destroy a small VM in a non-production Proxmox environment
- Verify tags and initialization applied correctly

Local quick checks:
- make fmt
- make validate
