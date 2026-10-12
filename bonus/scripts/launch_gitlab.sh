#!/bin/bash

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=gitlab-demo42.com \
  --set global.hosts.externalIP=192.168.56.113 \
  --set certmanager-issuer.email=me@example.com
kubectl port-forward svc/gitlab-svc -n gitlab 8088:443 > /tmp/gitlab-pf.log 2>&1
kubectl apply -n gitlab --server-side --force-conflicts -f ./confs/values.yaml