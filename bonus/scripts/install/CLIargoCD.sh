#!/bin/bash

if command -v argocd >/dev/null 2>&1; then
	echo "argocdCLI already install"
else
	echo "argocdCLI is not installed"
	curl -sSL -o argocd \
	https://github.com/argoproj/argo-cd/releases/download/v3.4.5/argocd-linux-amd64
	chmod +x argocd
	sudo mv argocd /usr/local/bin/
	echo "argoCLI has been installed"
fi