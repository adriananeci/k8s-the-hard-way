#!/usr/bin/env bash

curl -so cfssl https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/darwin/cfssl
curl -so cfssljson https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/darwin/cfssljson

chmod +x cfssl cfssljson
sudo mv cfssl cfssljson /usr/local/bin/

echo "### cfssl version: ###"
cfssl version

echo "### cfssljson version: ###"
cfssljson --version

curl -sLO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "### kubectl version: ###"
kubectl version --client