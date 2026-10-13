apt-get update
apt-get install -y curl

mkdir -p "/etc/rancher/k3s"
mv /tmp/config.yaml /etc/rancher/k3s/config.yaml
chmod 600 /etc/rancher/k3s/config.yaml

curl -sfL https://get.k3s.io | sh -
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/k3s-token
chmod 644 /vagrant/k3s-token
