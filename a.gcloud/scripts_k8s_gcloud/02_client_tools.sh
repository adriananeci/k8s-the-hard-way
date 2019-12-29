#!/usr/bin/env bash

kubectl_stable=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

path_location="/usr/local/bin/"
extension=""

if [[ ${os} == "windows" ]]
then
    path_location="/usr/bin/"
    extension=".exe"
fi

curl -so kubectl "https://storage.googleapis.com/kubernetes-release/release/${kubectl_stable}/bin/${os}/amd64/kubectl${extension}"
curl -so cfssl "https://pkg.cfssl.org/R1.2/cfssl_${os}-amd64${extension}"
curl -so cfssljson "https://pkg.cfssl.org/R1.2/cfssljson_${os}-amd64${extension}"
chmod +x kubectl cfssl cfssljson
sudo mv kubectl cfssl cfssljson /usr/bin/

echo "### cfssl version: ###"
cfssl version

echo "### cfssljson version: ###"
cfssljson --version

echo "### kubectl version: ###"
kubectl version --client