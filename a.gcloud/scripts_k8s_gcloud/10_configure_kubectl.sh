#!/usr/bin/env bash

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=certs/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

# In case of windows OS we need to embed admin cert and key in kube config
# otherwise we can hit error: Rel: can't make PWD\certs\admin.pem relative to C:\Users\<user>\.kube
embed_certs=""
if [[ ${os} == "windows" ]]
then
    embed_certs="--embed-certs=true"
fi

kubectl config set-credentials admin \
  --client-certificate=certs/admin.pem \
  --client-key=certs/admin-key.pem \
  ${embed_certs}

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way

kubectl get componentstatuses
kubectl get nodes -o wide
