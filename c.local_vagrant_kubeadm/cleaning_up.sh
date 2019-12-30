#!/usr/bin/env bash

cd scripts_kubeadm_local

vagrant destroy -f

rm -rf {kubeadmin_init,kubeconfig}