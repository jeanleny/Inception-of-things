#!/bin/bash

./scripts/install/kubectl.sh
./scripts/install/k3d.sh
./scripts/install/CLIargoCD.sh
./scripts/install/docker.sh
./scripts/install/helm.sh

source ./scripts/launch_cluster.sh

source ./scripts/launch_argocd.sh

source ./scripts/create_application_gitlab.sh

source ./scripts/create_application_wil.sh

echo "----------------- ARGOCD ------------------"
echo "user for argocd : admin"
echo "password for argocd : $ARGOCD_PASSWORD"
echo "Port-forward actif (PID $PF_PID_ARGOCD), logs : /tmp/argocd-pf.log"
echo "Pour l'arrêter : kill $PF_PID_ARGOCD"
echo "----------------- GITLAB ------------------"
echo "user for gitlab : root"
echo "password for gitlab : $GITLAB_PASSWORD"
echo "Port-forward actif (PID $PF_PID_GITLAB), logs : /tmp/gitlab-pf.log"
echo "Pour l'arrêter : kill $PF_PID_GITLAB"
