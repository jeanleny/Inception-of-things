#!/bin/bash

if command -v helm >/dev/null 2>&1; then
    echo "helm already installed"
else
    echo "helm is not installed"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4   
    chmod 700 get_helm.sh
    ./get_helm.sh   
    helm version
    echo "helm has been installed"
fi