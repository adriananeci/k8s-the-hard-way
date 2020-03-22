#!/usr/bin/env bash

for instance in worker-0 worker-1; do
    vagrant ssh  ${instance} -c '''

INTERNAL_IP=$(ip address show | grep \"inet 10.240\" | sed -e \"s/^.*inet //\" -e \"s/\/.*$//\" | tr -d \"\n\" 2>/dev/null)

cat <<EOF | sudo tee --append /etc/default/kubelet >/dev/null
KUBELET_EXTRA_ARGS=--node-ip=${INTERNAL_IP}
EOF

cluster_join=\"\"

while [[ \"${cluster_join}\" == \"\" ]] ; do
    echo \"waiting for the master node\"
    sleep 1
    cluster_join=$(cat /vagrant/kubeadmin_init  | grep -A2 \"kubeadm join\" | sed \"s/\\\\\\\\//g\")
done

sudo $cluster_join

apt-get install nfs-common -y
'''
done

vagrant ssh master -c "kubectl get nodes -o wide"
