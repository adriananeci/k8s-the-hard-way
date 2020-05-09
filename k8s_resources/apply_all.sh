#!/usr/bin/env bash

dir_path=$(realpath $(dirname $0))

### 1. Apply monitoring stack
scratch_directory=$(mktemp -d)
cleanup() {
  rm -rf "$scratch_directory"
}
trap cleanup EXIT
trap cleanup SIGINT

pushd "$scratch_directory" || exit 1
if ! git clone https://github.com/coreos/kube-prometheus.git; then
  echo "An error occurred when cloning coreos/kube-prometheus"
  exit 1
fi

cd  kube-prometheus

# Update libsonnet libraries
jb update

# Build monitoring manifest based on our jsonnet
./build.sh ${dir_path}/monitoring_stack/monitoring.jsonnet

# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl create -f manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
# Create monitoring resources
kubectl create -f manifests/

popd || exit 1

### 2. Create nginx-ingress controller resources
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
kubectl create ns ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx \
    --set controller.service.type=NodePort \
    --set controller.service.nodePorts.https=30443 \
    --set controller.service.nodePorts.http=30080 \
    --set controller.service.nodePorts.tcp.8080=38080

### 3. Apply remaining manifests
kubectl apply -R -f ${dir_path}