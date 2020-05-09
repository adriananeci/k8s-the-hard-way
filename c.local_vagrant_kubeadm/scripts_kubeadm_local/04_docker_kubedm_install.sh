#!/usr/bin/env bash

for instance in master worker-0 worker-1; do
    vagrant ssh  ${instance} -c '''
function prepare_docker()
{
    # Install Docker CE
    apt-get update -qq && apt-get upgrade -qq > /dev/null
    apt-get install -qq apt-transport-https ca-certificates curl gnupg-agent software-properties-common > /dev/null
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    #TODO remove bionic with lsb_release after focal(ubuntu 20.04) docker repo is available
    add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        bionic \
        stable\"
        # $(lsb_release -cs) \
    apt-get update -qq
    apt-get install -qq docker-ce > /dev/null

    # Setup daemon.
    cat > /etc/docker/daemon.json <<EOF
{
  \"exec-opts\": [\"native.cgroupdriver=systemd\"],
  \"log-driver\": \"json-file\",
  \"log-opts\": {
    \"max-size\": \"100m\"
  },
  \"storage-driver\": \"overlay2\"
}
EOF

    mkdir -p /etc/systemd/system/docker.service.d

    # Restart docker.
    systemctl daemon-reload
    systemctl restart docker
}

function prepare_kube()
{
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    apt-get update -qq

    #kubectl_stable=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    #apt-get install -qq kubelet=${kubectl_stable} kubeadm=${kubectl_stable} kubectl=${kubectl_stable} > /dev/null
    apt-get install -qq kubelet kubeadm kubectl --allow-change-held-packages > /dev/null
    apt-mark hold kubelet kubeadm kubectl
}

sudo bash -c \"$(declare -f prepare_docker); prepare_docker\"
sudo bash -c \"$(declare -f prepare_kube); prepare_kube\"
'''
done
