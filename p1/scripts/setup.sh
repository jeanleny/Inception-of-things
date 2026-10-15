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

sudo apt install -y gnupg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc \
  | sudo gpg --dearmor --yes -o /usr/share/keyrings/oracle-virtualbox-2016.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian trixie contrib" \
  | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update
sudo apt install -y virtualbox-7.2

sudo apt update
sudo apt install cockpit cockpit-machines
sudo modprobe -r kvm_intel
sudo modprobe -r kvm
vagrant up
