# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
SHELL := /bin/bash
INSTANCES = 2 # 2 instance by default

help: ## This help.
		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

hooks: ## installss pre-commit hook (format, dialyzer and white spaces check)
	  brew install pre-commit
	  pre-commit install

docs: ## generate docs and opens the index.html
		mix deps.get
		mix compile
		mix docs
		open doc/index.html
