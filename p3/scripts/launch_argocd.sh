#!/bin/bash

kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

kubectl port-forward svc/argocd-server -n argocd 8080:443 > /tmp/argocd-pf.log 2>&1 &
PF_PID=$!

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d)

argocd login localhost:8080 --username admin --password "$ARGOCD_PASSWORD" --insecure

echo "password de argocd : $ARGOCD_PASSWORD"
echo "Port-forward actif (PID $PF_PID), logs : /tmp/argocd-pf.log"
echo "Pour l'arrêter : kill $PF_PID"