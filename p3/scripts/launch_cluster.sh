#!/bin/bash

k3d cluster create 42cluster --servers 1 --agents 1 -p "8888:80@loadbalancer"
kubectl get nodes -o wide

kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.4.5/manifests/install.yaml
