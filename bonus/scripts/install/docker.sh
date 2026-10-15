#!/bin/bash

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
	su $USER
	echo "docker has been installed, thanks to reboot and relaunch script"
fi
