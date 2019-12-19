#!/usr/bin/env bash

cd scripts_k8s_gcloud

#./01_prerequisites.sh
./02_client_tools.sh
./03_compute_resources.sh
./04_certificate_authority.sh
./05_k8s_config_files.sh
./06_data_encryption_keys.sh
./07_bootstrap_etcd.sh
./08_bootstrap_control_plane.sh
#./09_bootstrap_k8s_workers.sh
#./10_configure_kubectl.sh
#./11_pod_network_routes.sh
#./12_dns_addon.sh
#./13_smoke_test.sh

#./14_cleaning_up.sh