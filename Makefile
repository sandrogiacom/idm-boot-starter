#
# Copyright 2019, TOTVS S.A.
# All rights reserved.
#
JAVA_HOME ?= /usr/java/jdk-11.0.1

# Rule "target:clean"
.PHONY: target\:clean
.SILENT: target\:clean
target\:clean:
	# produce a failure return code if any command return error \
	set -euo pipefail; \
	# set and create target folder \
	targetFolder=$(shell git rev-parse --show-toplevel)/target; \
	# remove target folder if exist \
	if test -d $$targetFolder; then \
		rm -rf $$targetFolder; \
	fi;

# defaul shell
SHELL = /bin/bash

# if version is not defined, use commit hash as version
VERSION ?= $(shell git rev-parse --short=7 HEAD)

# Rule "sonar:check"
.PHONY: sonar\:check
.SILENT: sonar\:check
sonar\:check:
	# produce a failure return code if any command return error \
	set -eo pipefail; \
   mvn jacoco:merge;
#   mvn sonar:sonar -Dsonar.projectKey=your-project \
#   -Dsonar.host.url=https://sonar.fluig.com \
#   -Dsonar.login=your-login \
#   -Dsonar.jacoco.reportPaths=../target/jacoco.exec;

# Rule "pre_build"
.PHONY: pre_build
.SILENT: pre_build
pre_build:
	# produce a failure return code if any command return error \
	set -eo pipefail;

# Rule "build"
.PHONY: build
.SILENT: build
build:
	# produce a failure return code if any command return error \
	set -euo pipefail; \
	# root of git repository \
	rootRepo=$(shell git rev-parse --show-toplevel); \
	wget -q https://s3-sa-east-1.amazonaws.com/make-utils.fluig.io/MakeUtils -O MakeUtils; \
	mv MakeUtils ./docker/MakeUtils; \
    make -s maven:build -f ./docker/MakeUtils -e MVN_ARGS="-U -Pintegration-test"; \
    make -s docker:build -f ./docker/MakeUtils;

# Rule "build_local"
.PHONY: build_local
.SILENT: build_local
build_local:
	# produce a failure return code if any command return error \
	set -euo pipefail; \
	# root of git repository \
	rootRepo=$(shell git rev-parse --show-toplevel); \
	wget -q https://s3-sa-east-1.amazonaws.com/make-utils.fluig.io/MakeUtils -O MakeUtils; \
	mv MakeUtils ./docker/MakeUtils; \
    make -s maven:build -f ./docker/MakeUtils -e MVN_ARGS="-U -Pintegration-test"; \
    make -s build_local -f ./docker/Makefile;

# Rule "post_build"
.PHONY: post_build
.SILENT: post_build
post_build:
	# produce a failure return code if any command return error \
	set -eo pipefail; \
    make sonar:check \

k-setup:
	rm  ~/.config/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases; \
	rm  ~/.config/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases-prev; \
	minikube -p identity start --cpus 2 --memory=4098; \
	minikube -p identity addons enable ingress; \
	minikube -p identity addons enable metrics-server; \
	kubectl create namespace identity

k-deploy-app:
	kubectl apply -f k8s.local/app/;

k-delete-app:
	kubectl delete -f k8s.local/app/;

k-deploy-es:
	kubectl apply -f k8s.local/es/;

k-delete-es:
	kubectl delete -f k8s.local/es/;

k-build-image:
	eval $$(minikube -p identity docker-env) && make build-local;
