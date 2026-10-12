#!/bin/bash

argocd app create gitlab \
  --repo https://github.com/blanchetamaury/IOT_gitlab \
  --path gitlab_demo \
  --sync-policy automated \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace gitlab

until kubectl logs deployment/gitlab -n gitlab | grep -i "chef infra client finished\|gitlab reconfigured" >/dev/null; do sleep 10; done

kubectl port-forward -n gitlab svc/gitlab-svc 8088:8088 > /tmp/gitlab-pf.log 2>&1 &
PF_PID=$!

echo "Port-forward actif (PID $PF_PID), logs : /tmp/gitlab-pf.log"
echo "Pour l'arrêter : kill $PF_PID"

until curl -ksf http://127.0.0.1:8088 >/dev/null; do sleep 1; done