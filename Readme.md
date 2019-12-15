# K8S the hard way based on [kelsey hightower repo](https://github.com/kelseyhightower/kubernetes-the-hard-way)

All resources are deployed in google cloud. You can create a free account and get a 300$ for free.
These money should be enough to get accommodated with main k8s components 

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
### TODO - add more options to deploy k8s (maybe aws, vagrant or bare-metal)

