#!/bin/bash

k3d cluster create 42cluster --servers 1 -p "8888:80@loadbalancer" --k3s-arg "--disable=traefik@server:*"
kubectl get nodes -o wide

kubectl create namespace argocd
kubectl create namespace gitlab
kubectl create namespace dev
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.4.5/manifests/install.yaml

# Helm traefik

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm upgrade --install traefik traefik/traefik \
  --timeout 600s \
  --set global.hosts.domain=traefik-demo42.com \
  --set global.hosts.externalIP=192.168.56.114 \

# Helm gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab -n gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=gitlab-demo42.com \
  --set global.hosts.externalIP=192.168.56.113 \
  --set certmanager-issuer.email=me@example.com \
