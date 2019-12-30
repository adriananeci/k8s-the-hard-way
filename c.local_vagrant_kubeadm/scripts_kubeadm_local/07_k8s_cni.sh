#!/usr/bin/env bash

export KUBECONFIG=kubeconfig

nc_command="nc"
command -v ${nc_command} >/dev/null 2>&1 || nc_command="ncat"

#Sleep to wait for controller-0 to come up
echo "Waiting for kube api-server to come up ..."
KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh master -c "ip address show | grep 'inet 10.240' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'" 2>/dev/null)

while ! ${nc_command} -z ${KUBERNETES_PUBLIC_ADDRESS} 6443
do
   sleep 10; echo "Sleeping another 10 seconds ..."
done

kubectl apply -f ../../cni/calico/calico.yaml

kubectl get pods -l k8s-app=kube-dns -n kube-system

kubectl run --generator=run-pod/v1 busybox --image=busybox:1.28 --command -- sleep 3600
kubectl get pods -l run=busybox
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

while [[ $(kubectl get pods -l run=busybox -o jsonpath="{..status.conditions[?(@.type=='Ready')].status}") != "True" ]];
do echo "waiting for pod ${POD_NAME} to become ready!" && sleep 3; done

kubectl exec -ti ${POD_NAME} -- nslookup kubernetes

kubectl get componentstatuses
kubectl get nodes -o wide
