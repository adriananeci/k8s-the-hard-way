#!/usr/bin/env bash

cd scripts_vagrant_local

# Get OS type
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine="linux";;
    Darwin*)    machine="darwin";;
    CYGWIN*)    machine="windows";;
    MINGW*)     machine="windows";;
    *)          machine="UNKNOWN:${unameOut}" && exit 1
esac

echo ${machine} && export os=${machine}

if [[ ${os} != "windows" ]]
then
    find . -type f -exec sed -i '' -e 's/\\"/"/g; s/\\\\/\\/g' {} \;
fi

./01_prerequisites.sh
./02_client_tools.sh
./03_compute_resources.sh
./04_certificate_authority.sh
./05_k8s_config_files.sh
./06_data_encryption_keys.sh
./07_bootstrap_etcd.sh
./08_bootstrap_control_plane.sh
./09_bootstrap_k8s_workers.sh
./10_configure_kubectl.sh
./11_pod_network_routes.sh
./12_dns_addon.sh
./13_smoke_test.sh

#./14_cleaning_up.sh