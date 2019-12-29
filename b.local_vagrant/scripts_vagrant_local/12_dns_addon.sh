#!/usr/bin/env bash

kubectl config set-context --current --namespace default

#kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
kubectl apply -f ../../k8s_resources/coredns.yaml

kubectl get pods -l k8s-app=kube-dns -n kube-system

kubectl run --generator=run-pod/v1 busybox --image=busybox:1.28 --command -- sleep 3600
kubectl get pods -l run=busybox
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

while [[ $(kubectl get pods -l run=busybox -o jsonpath="{..status.conditions[?(@.type=='Ready')].status}") != "True" ]];
do echo "waiting for pod ${POD_NAME} to become ready!" && sleep 3; done

kubectl exec -ti ${POD_NAME} -- nslookup kubernetes
