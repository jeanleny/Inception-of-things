#!/bin/bash

#=======================#
#installation de kubectl#
#=======================#
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

#=======================#
#installation de k3s    #
#=======================#
if command -v k3d >/dev/null 2>&1; then
	echo "k3d already install"
else
	echo "k3d is not installed"
	K3D_VERSION=v5.9.0
	cd /tmp
	base="https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}"
	curl -sSfLO "${base}/k3d-linux-amd64"
	curl -sSfLO "${base}/checksums.txt"
	# Vérifier l'empreinte SHA256 avant d'installer
	expected=$(grep 'k3d-linux-amd64$' checksums.txt | awk '{print $1}')
	echo "${expected}  k3d-linux-amd64" | sha256sum -c -
	sudo install -m 0755 k3d-linux-amd64 /usr/local/bin/k3d
	k3d version
	echo "k3d has been installed"	
fi

#==========================#
#installation de CLIArgoCD #
#==========================#
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

#=======================#
#installation de docker #
#=======================#
if command -v docker >/dev/null 2>&1; then
	echo "docker already install"
else
	echo "docker is not installed"
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
	sudo apt-get update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	sudo systemctl enable docker
	sudo usermod -aG docker "$USER"
	echo "docker has been installed, thanks to reboot and relaunch script"
fi
