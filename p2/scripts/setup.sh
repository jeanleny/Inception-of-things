#!/bin/bash

set -eo pipefail
apt update
apt install -y curl
curl -sfL https://get.k3s.io -o k3s-install.sh
K3S_KUBECONFIG_MODE="644" sh k3s-install.sh

kubectl apply -f /vagrant/confs/app1/deployment.yaml 
kubectl rollout status deployment/app1 --timeout=120s
kubectl apply -f /vagrant/confs/app1/service.yaml 

kubectl apply -f /vagrant/confs/app2/deployment.yaml 
kubectl rollout status deployment/app2 --timeout=120s
kubectl apply -f /vagrant/confs/app2/service.yaml 

kubectl apply -f /vagrant/confs/app3/deployment.yaml 
kubectl rollout status deployment/app3 --timeout=120s
kubectl apply -f /vagrant/confs/app3/service.yaml 

kubectl apply -f /vagrant/confs/ingress.yaml 
