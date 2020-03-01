#!/usr/bin/env bash

for instance in master worker-0 worker-1; do
    vagrant ssh ${instance} -c '''
    cat <<EOF | sudo tee --append /etc/hosts >/dev/null
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
EOF
'''
done

kubectl apply -f ../../cni/calico/calico.yaml
