.PHONY: fmt fmt-check validate lint check

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -recursive -check

validate:
	terraform init -backend=false
	terraform validate

lint:
	tflint --init
	tflint --recursive

check: fmt-check validate lint
