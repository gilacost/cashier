# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
SHELL := /bin/bash
INSTANCES = 2 # 2 instance by default

help: ## This help.
		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

hooks: ## installss pre-commit hook
	  brew install pre-commit
	  pre-commit install

docs: ## generate docs and opens the index.html
		mix deps.get
		mix compile
		mix docs
		open doc/index.html

asdf: ## Installs asdf and asdf plugins
		git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2 >> /dev/null 2>&1
		asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git >> /dev/null 2>&1
		asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git >>  /dev/null 2>&1
		asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git >>  /dev/null 2>&1

install: ## Runs asdf install
	  asdf install
