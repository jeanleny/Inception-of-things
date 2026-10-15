#!/bin/bash

if command -v kubectl >/dev/null 2>&1; then
	echo "kubectl already install"
else
	echo "kubectl is not installed"
	curl  -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
	kubectl version --client
	echo "kubctl has been successfully installed"
fi