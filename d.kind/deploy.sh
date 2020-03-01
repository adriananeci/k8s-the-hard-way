#!/bin/bash

#https://kind.sigs.k8s.io/docs/user/quick-start/
sed -i.bak "s/API_SERVER_IP/$(ipconfig getifaddr en0)/g" kind-config.yaml
kind create cluster --config kind-config.yaml

sed -i.bak "s/0.0.0.0/$(ipconfig getifaddr en0)/g" ~/.kube/config
kubectl cluster-info
sleep 30
#install cilium
echo "Installing Cilium"
#kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.7/install/kubernetes/quick-install.yaml

kubectl get no -o wide | grep control-plane | head -1 | awk '{print $6}'
sed "s/API_SERVER_IP/$(kubectl get no -o wide | grep control-plane | head -1 | awk '{print $6}')/g" cilium.yaml | kubectl apply -f -

#echo "installing cilium hubble"
#kubectl apply -f https://raw.githubusercontent.com/cilium/hubble/master/tutorials/deploy-hubble-servicemap/hubble-all-minikube.yaml

# for accesing hubble
# export NAMESPACE=kube-system
# export POD_NAME=$(kubectl get pods --namespace $NAMESPACE -l "k8s-app=hubble-ui" -o jsonpath="{.items[0].metadata.name}")
# kubectl --namespace $NAMESPACE port-forward $POD_NAME 12000

# install calico
#echo "Installing Calico"
#kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
#kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true

# install contour
echo "Installing contour"
#kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
#kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'

# install metric-server
echo "Installing metrics-server"
kubectl apply -f ../k8s_resources/metrics-server/

kubectl get nodes

kubectl get cs
