#!/bin/bash

argocd app create wil42 \
  --repo https://github.com/blanchetamaury/IOT_image \
  --path wil42_demo \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default   