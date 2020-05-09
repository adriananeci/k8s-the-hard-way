#!/usr/bin/env bash

kubectl config set-context --current --namespace default

kubectl create secret generic kubernetes-the-hard-way \
  --from-literal="mykey=mydata"

gcloud compute ssh controller-0 \
  --command "sudo ETCDCTL_API=3 etcdctl get \
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
curl -s --head http://127.0.0.1:8080
kubectl logs ${POD_NAME}
kubectl exec -ti ${POD_NAME} -- nginx -v
kubectl expose deployment nginx --port 80 --type NodePort

NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

gcloud compute firewall-rules create kubernetes-the-hard-way-allow-nginx-service \
  --allow=tcp:${NODE_PORT} \
  --network kubernetes-the-hard-way

EXTERNAL_IP=$(gcloud compute instances describe worker-0 \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

curl -s -I http://${EXTERNAL_IP}:${NODE_PORT}

# create k8s resources
./../../k8s_resources/apply_all.sh

kubectl get componentstatuses
kubectl get nodes -o wide