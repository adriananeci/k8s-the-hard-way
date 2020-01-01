#!/usr/bin/env bash

cd scripts_vagrant_local

# Get OS type
function get_os()
{
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     machine="linux";;
        Darwin*)    machine="darwin";;
        CYGWIN*)    machine="windows";;
        MINGW*)     machine="windows";;
        *)          machine="UNKNOWN:${unameOut}" && exit 1
    esac

    echo ${machine} && export os=${machine}
}

function box_out()
{
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 3
  echo " -${b//?/-}-
| ${b//?/ } |"
  for l in "${s[@]}"; do
    printf '| %s%*s%s |\n' "$(tput setaf 4)" "-$w" "$l" "$(tput setaf 3)"
  done
  echo "| ${b//?/ } |
 -${b//?/-}-"
  tput sgr 0
}

get_os

if [[ ${os} != "windows" ]]
then
    find . -type f -exec sed -i '' -e 's/\\"/"/g; s/\\\\/\\/g' {} \;
fi

box_out "01_prerequisites"
./01_prerequisites.sh

box_out "02_client_tools"
./02_client_tools.sh

box_out "03_compute_resources"
./03_compute_resources.sh

box_out "04_certificate_authority"
./04_certificate_authority.sh

box_out "05_k8s_config_files"
./05_k8s_config_files.sh

box_out "06_data_encryption_keys"
./06_data_encryption_keys.sh

box_out "07_bootstrap_etcd"
./07_bootstrap_etcd.sh

box_out "08_bootstrap_control_plane"
./08_bootstrap_control_plane.sh

box_out "09_bootstrap_k8s_workers"
./09_bootstrap_k8s_workers.sh

box_out "10_configure_kubectl"
./10_configure_kubectl.sh

box_out "11_pod_network_routes"
./11_pod_network_routes.sh

box_out "12_dns_addon"
./12_dns_addon.sh

box_out "13_smoke_test"
./13_smoke_test.sh

#./14_cleaning_up.sh