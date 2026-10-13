#!/bin/bash

#vagrant setup
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

if ! vagrant --version; then
	echo installation went wrong
else
	echo installation went well
fi

sudo apt update
sudo apt install cockpit cockpit-machines
vagrant init generic/debian10
vagrant up
vagrant ssh
