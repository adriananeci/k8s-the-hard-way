# K8S the hard way based on [kelsey hightower repo](https://github.com/kelseyhightower/kubernetes-the-hard-way)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fadriananeci%2Fk8s-the-hard-way.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fadriananeci%2Fk8s-the-hard-way?ref=badge_shield)


## K8s cluster can be deployed in 2 ways (tested on Windows and MacOS but should work also on Linux):
### a. using google cloud
```
cd a.gcloud
```
All resources are deployed in google cloud. You can create a free account and get a 300$ for free.
These money should be enough to get accommodated with main k8s components.
Deploy script will spin up 6 VMs, 3 masters and 3 worker nodes. 
You have to install [gcloud](https://cloud.google.com/sdk/install) prior to run deploy script
### b. locally, using vagrant
```
cd b.local_vagrant
```
Deploy script will spin up 3 VMs, 1 master and 2 worker nodes.
You have to install [vagrant](https://www.vagrantup.com/downloads.html) and [virtualBox](https://www.virtualbox.org/wiki/Downloads) (and also [git-bash](https://git-scm.com/downloads) in case of windows OS) prior to run deploy script

## Quick setup
```
./deploy_all.sh
```

## Quick view
In order to access k8s dashboard run 
```
kubectl proxy
```

Open your browser and access 
```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

Select token authentication and enter the below output command token:
```
kubectl -n kube-system describe secret \
$(kubectl -n kube-system get secret | grep admin | awk '{print $1}') | \
egrep "token:" | cut -d ':' -f2 |tr -d ' '
```


## Clean-up
```
./cleaning_up.sh
```

### Useful commands
```
kubectl api-versions
kubectl api-resources

kubectl get componentstatuses
kubectl get --raw /healthz

kubectl describe apiservice v1beta1.metrics.k8s.io
kubectl get --raw "/apis/metrics.k8s.io" | jq .
kubectl get apiservice

kubectl explain deployment --recursive
kubectl logs dashboard-metrics-scraper-xxx -f

kubectl edit deployment metrics-server

kubectl create serviceaccount dashboard-admin
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin
kubectl get roles.rbac.authorization.k8s.io
kubectl get sa

kubectl get secret --all-namespaces
kubectl describe secret kubernetes-dashboard-token-gjpqk

kubectl config view

alias k='kubectl'
alias kns='kubectl config set-context --current --namespace'

kns kube-system
k get po,svc --all-namespaces

k get ev (get events)
k get cs (componentstatuses)
k get limits --all-namespaces (LimitRange)
k get pdb --all-namespaces (PodDisruptionBudget)
k get quota --all-namespaces (ResourceQuota)
k get hpa --all-namespaces (HorizontalPodAutoscaler)
k get netpol --all-namespaces (NetworkPolicy)
```

### ServiceAccount
```
k create ns test
kns test
k create serviceaccount test
k create role test-role --verb=get --verb=list --resource=services
k create rolebinding test-rb --role=test-role --serviceaccount=test:test

k run test --image=ubuntu --serviceaccount=test -it -- bash
curl -k https://172.16.11.1/api/v1/namespaces/test/services -H 'Accept: application/json' -H "Authorization: Bearer $(cat /run/secrets/kubernetes.io/serviceaccount/token)" --works
curl -k https://172.16.11.1/api/v1/namespaces/test/pods -H 'Accept: application/json' -H "Authorization: Bearer $(cat /run/secrets/kubernetes.io/serviceaccount/tokn)" --forbidden

k delete deploy test
```

### Tips & Tricks

* List all Persistent Volumes sorted by their name
```
kubectl get pv | grep -v NAME | sort -k 2 -rh
```
* Find which pod is taking max CPU
```
kubectl top pod
```
* Getting a Detailed Snapshot of the Cluster State
```
kubectl cluster-info dump --all-namespaces > cluster-state
```
* Save the manifest of a running pod
```
kubectl get pod name -o yaml --export > pod.yml
```
* Save the manifest of a running deployment
```
kubectl get deploy name -o yaml --export > deploy.yml
```
* Use dry-run to create a manifest for a deployment
```
kubectl run ghost --image=ghost --restart=Always --expose --port=80 --output=yaml --dry-run > ghost.yaml
k apply -f ghost.yaml
k get all
```
Delete evicted pods
```
kubectl get po -A -o json | \
jq  '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | \
"kubectl delete po \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
```
* Find all deployments which have no resource limits set
```
kubectl get deploy -o json | \
jq ".items[] | select(.spec.template.spec.containers[].resources.limits==null) | {DeploymentName:.metadata.name}"
```
* Create a yaml for a job
```
kubectl run --generator=job/v1 test --image=nginx --dry-run -o yaml
```
* Find all pods in the cluster which are not running
```
kubectl get pod --all-namespaces  -o json | jq  '.items[] | select(.status.phase!="Running") | [ .metadata.namespace,.metadata.name,.status.phase ] | join(":")'
```
* List all pods order by MEM usage
```
kubectl top pods --no-headers -A | sort --reverse --numeric -k 4
```
* List the top 3 nodes with the highest CPU usage
```
kubectl top nodes | sort --reverse --numeric -k 3 | head -n3
```
* List the top 3 nodes with the highest MEM usage
```
kubectl top nodes | sort --reverse --numeric -k 5 | head -n3
```
* Get rolling Update details for deployments
```
kubectl get deploy -o json |
 jq ".items[] | {name:.metadata.name} + .spec.strategy.rollingUpdate"
```
* List pods and its corresponding containers
```
kubectl get pods -o='custom-columns=PODS:.metadata.name,CONTAINERS:.spec.containers[*].name'
```
* Get quota for each node:
```
kubectl get nodes --no-headers | awk '{print $1}' | xargs -I {} sh -c 'echo {}; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo'
```
* Get nodes which have no taints
```
kubectl get nodes -o json | jq  -r '.items[] | select(.spec.taints == null) | "\(.metadata.name)"'
```
### What happens when running kubectl
[WhatHappensWhenKubectl](WhatHappensWhenKubectl.md)
### Other useful links
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

https://matthewdavis.io/kubectl-most-useful-commands-a-growing-list/

https://github.com/dennyzhang/cheatsheet-kubernetes-A4

http://kubernetesbyexample.com/

http://crunchtools.com/competition-heats-up-between-cri-o-and-containerd-actually-thats-not-a-thing/

https://itnext.io/benchmark-results-of-kubernetes-network-plugins-cni-over-10gbit-s-network-updated-april-2019-4a9886efe9c4

### TODO - add more options to deploy k8s (maybe aws)



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fadriananeci%2Fk8s-the-hard-way.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fadriananeci%2Fk8s-the-hard-way?ref=badge_large)