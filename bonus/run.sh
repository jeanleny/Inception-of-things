#!/bin/bash

./scripts/install/kubectl.sh
./scripts/install/k3d.sh
./scripts/install/CLIargoCD.sh
./scripts/install/docker.sh

./scripts/launch_cluster.sh

./scripts/launch_argocd.sh

kubectl apply -f ./confs/ingress.yaml

./scripts/create_application.sh