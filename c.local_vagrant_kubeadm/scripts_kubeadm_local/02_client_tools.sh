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
    [[ -f ~/bin/win-sudo/s/path.sh ]] && source ~/bin/win-sudo/s/path.sh
fi
curl -Lso kubectl "https://storage.googleapis.com/kubernetes-release/release/${kubectl_stable}/bin/${os}/amd64/kubectl${extension}"
chmod +x kubectl
sudo mv kubectl ${path_location}

echo "### kubectl version: ###"
kubectl version --client
