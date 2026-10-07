# Repository instructions

- Keep reusable modules focused and configurable through inputs. Configure providers in examples, not reusable modules.
- When changing a module's behavior or interface, update its README and a relevant example.
- Module READMEs are generated with `terraform-docs`; preserve the generated documentation markers and let the configured pre-commit hook update the content.
- Pin GitHub Actions to full commit SHAs and retain the corresponding version as an inline comment.
- Run `pre-commit run --all-files` before submitting changes. This runs Terraform formatting, validation, TFLint, and Terraform documentation checks; CI runs these checks for pull requests.
- Do not commit credentials, Terraform state, or machine-specific configuration.
