#!/usr/bin/env bash

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

INTERNAL_IP=$(vagrant ssh worker-0 -c "ip address show | grep 'inet 10.240' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'" 2>/dev/null)

curl -s -I http://${INTERNAL_IP}:${NODE_PORT}

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
kubectl create ns ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx \
    --set controller.service.type=NodePort \
    --set controller.service.nodePorts.https=30443 \
    --set controller.service.nodePorts.http=30080 \
    --set controller.service.nodePorts.tcp.8080=38080

# create k8s resources
./../../k8s_resources/apply_all.sh

kubectl get componentstatuses
kubectl get nodes -o wide
