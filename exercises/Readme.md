1. Create a yaml for job that calculates the value of pi
1. Create an Nginx Pod and attach an EmptyDir volume to it.
1. Create an Nginx deployment in the namespace “kube-cologne” and corresponding service of type NodePort . Service should be accessible on HTTP (80) and HTTPS (443)
1. Add label to a node as "arch=gpu"
1. Create a Role in the “conference” namespace to grant read access to pods.
1. Create a RoleBinding to grant the "pod-reader" role to a user "john" within the “conference” namespace.
1. Create an Horizontal Pod Autoscaler to automatically scale the Deployment if the CPU usage is above 50%.
1. Deploy a default Network Policy for each resources in the default namespace to deny all ingress and egress traffic.
1. Create a pod that contain multiple containers : nginx, redis, postgres with a single YAML file.
1. Deploy nginx application but with extra security using PodSecurityPolicy
1. Create a Config map from file.
1. Create a Pod using the busybox image to display the entire content of the above ConfigMap mounted as Volumes.
1. Create configmap from literal values
1. Create a Pod using the busybox image to display the entire ConfigMap in environment variables automatically.


####More exercises for CKA at [k8s-cka-practice-questions](https://github.com/ipochi/k8s-practice-questions)

####More exercises for CKAD at [k8s-ckad-practice-questions](https://github.com/dgkanatsios/CKAD-exercises)