#!/usr/bin/env bash

vagrant ssh master -c bash -c '''
INTERNAL_IP=$(ip address show | grep \"inet 10.240\" | sed -e \"s/^.*inet //\" -e \"s/\/.*$//\" | tr -d \"\n\" 2>/dev/null)

# https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-part-2-bac431095706

cat <<EOF | sudo tee --append /etc/default/kubelet >/dev/null
KUBELET_EXTRA_ARGS=--node-ip=${INTERNAL_IP}
EOF

sudo kubeadm init --apiserver-advertise-address ${INTERNAL_IP} --pod-network-cidr 10.200.0.0/16  \\
     --service-cidr 172.16.11.0/24 --apiserver-cert-extra-sans \\
     k8s.local,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local \
     > /vagrant/kubeadmin_init

mkdir -p $HOME/.kube &&  \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \\
sudo chown $(id -u):$(id -g) $HOME/.kube/config && \\
cp $HOME/.kube/config /vagrant/kubeconfig

kubectl get nodes -o wide
'''
