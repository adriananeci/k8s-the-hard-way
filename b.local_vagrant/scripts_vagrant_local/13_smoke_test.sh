#!/usr/bin/env bash

kubectl config set-context --current --namespace default

kubectl create secret generic kubernetes-the-hard-way \
  --from-literal="mykey=mydata"

vagrant ssh master -c "sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem\
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C"

kubectl create deployment nginx --image=nginx
kubectl get pods -l app=nginx

POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath="{.items[0].metadata.name}")

while [[ $(kubectl get pods -l app=nginx -o jsonpath="{..status.conditions[?(@.type=='Ready')].status}") != "True" ]];
do echo "waiting for pod ${POD_NAME} to become ready!" && sleep 3; done

kubectl port-forward ${POD_NAME} 8080:80 &
curl --head http://127.0.0.1:8080
kubectl logs ${POD_NAME}
kubectl exec -ti ${POD_NAME} -- nginx -v
kubectl expose deployment nginx --port 80 --type NodePort

NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

INTERNAL_IP=$(vagrant ssh worker-0 -c "ip address show | grep 'inet 10.240' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'" 2>/dev/null)

curl -I http://${INTERNAL_IP}:${NODE_PORT}

cd .. && kubectl apply -R -f ../k8s_resources/

kubectl get componentstatuses
kubectl get nodes -o wide