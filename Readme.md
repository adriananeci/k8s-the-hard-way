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

### TODO - add more options to deploy k8s (maybe aws, vagrant or bare-metal)

