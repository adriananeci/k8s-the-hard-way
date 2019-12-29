#!/usr/bin/env bash

kubectl_stable=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

path_location="/usr/local/bin/"
extension=""

if [[ ${os} == "windows" ]]
then
    path_location="/usr/bin/"
    extension=".exe"

    # install sudo for git-bash
    curl -s https://raw.githubusercontent.com/imachug/win-sudo/master/install.sh | sh &> /dev/null
    . ~/.bashrc
fi
curl -Lso kubectl "https://storage.googleapis.com/kubernetes-release/release/${kubectl_stable}/bin/${os}/amd64/kubectl${extension}"
curl -Lso cfssl "https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_${os}_amd64${extension}"
curl -Lso cfssljson "https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_${os}_amd64${extension}"
chmod +x kubectl cfssl cfssljson
sudo mv kubectl cfssl cfssljson ${path_location}

echo "### cfssl version: ###"
cfssl version

echo "### cfssljson version: ###"
cfssljson --version

echo "### kubectl version: ###"
kubectl version --client
