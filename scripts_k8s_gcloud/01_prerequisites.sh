#!/usr/bin/env bash

gcloud version

gcloud init
gcloud auth login

gcloud config set compute/region europe-west3
gcloud config set compute/zone europe-west3-a
