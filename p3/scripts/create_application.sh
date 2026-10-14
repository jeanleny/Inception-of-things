#!/bin/bash

argocd app create wil42-p3 \
  --repo https://github.com/blanchetamaury/IOT_image \
  --path wil42_demo \
  --sync-policy automated \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev

kubectl apply -f ./confs/ingress.yaml
