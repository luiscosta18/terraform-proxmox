.PHONY: fmt init validate package

fmt:
	terraform fmt -recursive

init:
	( cd examples/simple && terraform init -input=false )

validate:
	( cd examples/simple && terraform init -input=false && terraform validate )

package:
	git archive --format=zip --output=terraform-proxmox-$(shell git rev-parse --short=8 HEAD).zip HEAD

test-readme:
	@echo "Run integration tests manually with credentials; see docs/structure.md"