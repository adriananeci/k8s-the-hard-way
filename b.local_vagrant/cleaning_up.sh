#!/usr/bin/env bash

cd scripts_vagrant_local

vagrant destroy -f

rm -rf {certs,kubeconfigs,encryption-config.yaml}
rm -f ../{.replaced_slashes,cfssl,cfssljson,kubectl}