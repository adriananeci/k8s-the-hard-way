#!/usr/bin/env bash

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

# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl create -f kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl create -f kube-prometheus/manifests/

popd || exit 1
