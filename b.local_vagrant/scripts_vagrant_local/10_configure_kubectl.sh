#!/usr/bin/env bash

KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh master -c "ip address show | grep 'inet 10.240' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'" 2>/dev/null)

kubectl config set-cluster kubernetes-the-hard-way-vagrant \
  --certificate-authority=certs/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

kubectl config set-credentials admin \
  --client-certificate=certs/admin.pem \
  --client-key=certs/admin-key.pem

kubectl config set-context kubernetes-the-hard-way-vagrant \
  --cluster=kubernetes-the-hard-way-vagrant \
  --user=admin

kubectl config use-context kubernetes-the-hard-way-vagrant

kubectl get componentstatuses
kubectl get nodes
