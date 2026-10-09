#!/bin/bash

k3d cluster create 42cluster --servers 1 -p "8888:80@loadbalancer"
kubectl get nodes -o wide

kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.4.5/manifests/install.yaml

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=gitlab-demo42.com \
  --set global.hosts.externalIP=192.168.56.113 \
  --set certmanager-issuer.email=me@example.com
kubectl create namespace gitlab
kubectl apply -n gitlab --server-side --force-conflicts -f ./confs/values.yaml