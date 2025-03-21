# For at "make test" ikke skal tro katalogen test er parameteren
.PHONY: test
.DEFAULT_GOAL := help

help:
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

test: ## Kjører noen enkle tester
	for f in test/standard/OK-* ; do echo "Kjører $${f}..." ; ./commit-msg "$$f" ; done
	for f in test/standard/FAIL-* ; do echo "Kjører $${f}..." ; ./commit-msg "$$f" ; test $$? -ne 1 && exit 1; done ; exit 0
	for f in test/strict/OK-* ; do echo "Kjører $${f}..." ; ./commit-msg-strict "$$f" ; done
	for f in test/strict/FAIL-* ; do echo "Kjører $${f}..." ; ./commit-msg-strict "$$f" ; test $$? -ne 1 && exit 1; done ; exit 0
	@echo "Tester kjørt OK"
