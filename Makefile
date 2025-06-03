# For at "make test" ikke skal tro katalogen test er parameteren
.PHONY: test
.DEFAULT_GOAL := help

help:
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

test: ## Kjører tester 
	sh test/test-commit-msg.sh
	@echo "Tester kjørt OK"
