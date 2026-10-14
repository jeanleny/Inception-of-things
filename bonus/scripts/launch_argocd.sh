#!/bin/bash

kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

kubectl port-forward svc/argocd-server -n argocd 8080:443 > /tmp/argocd-pf.log 2>&1 &
export PF_PID_ARGOCD=$!

until curl -ksf https://127.0.0.1:8080/healthz >/dev/null; do sleep 1; done

export ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d)

argocd login localhost:8080 --username admin --password "$ARGOCD_PASSWORD" --insecure
