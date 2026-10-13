#!/bin/bash

argocd app create wil42 \
  --repo http://gitlab-svc.gitlab.svc.cluster.local:8088/root/wil42.git \
  --path wil42_demo \
  --sync-policy automated \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev
