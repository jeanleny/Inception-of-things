# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.synced_folder ".", "/vagrant", disabled: false
  
  #===========#
  #Premiere VM#
  #===========#
  
  config.vm.define "server" do |server|
    server.vm.hostname = "qumiraudS"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provider "virtualbox" do |vb|
     vb.memory = 1024
     vb.cpus = 1
     vb.name = "qumiraudS_VM"
    end

    server.vm.provision "file",
      source: "/home/vboxuser/config.yaml",
      destination: "/tmp/config.yaml"

    server.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y curl  
      mkdir -p "/etc/rancher/k3s"
      mv /tmp/config.yaml /etc/rancher/k3s/config.yaml
      chmod 600 /etc/rancher/k3s/config.yaml
      curl -sfL https://get.k3s.io | sh -
      sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/k3s-token
      chmod 644 /vagrant/k3s-token
    SHELL
  end

  #===========#
  #Deuxieme VM#
  #===========#
  config.vm.define "agent" do |agent|
    agent.vm.hostname = "qumiraudSW"
    agent.vm.network "private_network", ip: "192.168.56.111"

    agent.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "qumiraudSW_VM"
    end

    agent.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y curl
      while [ ! -f /vagrant/k3s-token ]; do
        sleep 2;
      done
      curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$(cat /vagrant/k3s-token) sh -
    SHELL
  end
end
