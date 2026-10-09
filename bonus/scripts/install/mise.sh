#!/bin/bash

if command -v mise >/dev/null 2>&1; then
    echo "mise already installed"
else
    echo "mise is not installed"
    curl -fsSL https://mise.run | sh 
    mise trust
    mise install
    mise version
    echo "mise has been installed"
fi