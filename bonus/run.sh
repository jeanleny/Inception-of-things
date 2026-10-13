#!/bin/bash

./scripts/install/kubectl.sh
./scripts/install/k3d.sh
./scripts/install/CLIargoCD.sh
./scripts/install/docker.sh
./scripts/install/helm.sh

./scripts/launch_cluster.sh

./scripts/launch_argocd.sh

# kubectl apply -f ./confs/ingress_gitlab.yaml
./scripts/create_application_gitlab.sh

kubectl apply -f ./confs/ingress_wil.yaml
./scripts/create_application_wil.sh