#!/bin/bash

argocd app create wil42 \
  --repo http://localhost:8088/laq/iot \
  --path wil42_demo \
  --sync-policy automated \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev
