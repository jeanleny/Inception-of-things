#!/bin/bash

argocd app create gitlab42 \
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

#GITLAB_PASSWORD=$(kubectl exec deployment/gitlab -n gitlab -- grep 'Password:' /etc/gitlab/initial_root_password | awk '{print $2}')

kubectl exec deployment/gitlab -n gitlab -- gitlab-rails runner "
user = User.find_by_username('root')
token = user.personal_access_tokens.create(
  scopes: [:api, :write_repository],
  name: 'automation',
  expires_at: 30.days.from_now
)
token.set_token('gitlab-token1234')
token.save!
"

curl --request POST "http://localhost:8088/api/v4/projects" \
  --header "PRIVATE-TOKEN: gitlab-token1234" \
  --data "name=wil42&visibility=public"

rm -rf wil42
git clone http://root:gitlab-token1234@localhost:8088/root/wil42.git
cp -r ./confs/wil42_demo ./wil42/
cd wil42
git add . && git commit -m "init" && git push
cd ..