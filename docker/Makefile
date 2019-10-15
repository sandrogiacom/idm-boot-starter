#
# Copyright TOTVS S.A.
# All rights reserved.
#
SHELL = /bin/bash

# if version is not defined, use commit hash as version
VERSION ?= $(shell git rev-parse --short=7 HEAD)
# image name
IMAGE = idm/idm-events-listener

# Define here the list of images that should be builded
LIST_OF_IMAGES_TO_BUILD := $(IMAGE)
export

# Rule "help"
help:
	@echo -e "\nUsage: make [target]\n\nTarget: \n"
	@grep -h "##" $(MAKEFILE_LIST) | grep -v "(help\|grep)" | sed -e "s/## //" -e 's/^/  /' -e 's/:/ -/'

# Rule "build"
.PHONY: build
build: ## Build the Dockerfile
	docker build --force-rm \
		--no-cache -t $(IMAGE):$(VERSION) \
		--build-arg IDM_VERSION=$(VERSION) \
		--file Dockerfile \
		$(shell git rev-parse --show-toplevel)

# Rule "build_local"
.PHONY: build_local
build_local: ## Build the Dockerfile
	rootRepo=$(shell git rev-parse --show-toplevel); \
	cd $$rootRepo/docker && \
	docker build --force-rm \
		--no-cache -t $(IMAGE):local \
		--file Dockerfile \
		$(shell git rev-parse --show-toplevel)

# Rule "push"
.SILENT: push
push:
	# produce a failure return code if any command return error \
	set -eo pipefail; \
	make push -f MakeUtils; \

# Rule "info"
.PHONY: info
.SILENT: info
info:
	# produce a failure return code if any command return error \
	set -eo pipefail; \
	make -s info -f MakeUtils;
