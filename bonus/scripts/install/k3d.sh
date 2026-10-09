#!/bin/bash

K3D_VERSION=v5.9.0

if command -v k3d >/dev/null 2>&1; then
    echo "k3d already installed"
else
    echo "k3d is not installed"
    curl -sSfL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=${K3D_VERSION} bash
    k3d version
    echo "k3d has been installed"
fi