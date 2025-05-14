minikube delete

minikube start --memory 4096 --cpus 2

minikube addons enable istio

cat 3-kiali-secret.yaml

echo pass | base64 -d

kubectl apply -f 3-kiali-secret.yaml

# Side car injection

kubectl describe ns default

kubectl label namespace default istio-injection=enabled

kubectl apply -f 4.application-full-sytack.yaml

kubectl get pods -n default

watch kubectl get pods -n default

minikube ip # take it :30080

# If you're using Docker Desktop, then you will use the IP address of "localhost" or "127.0.0.1".

# For example, to access the webapp, use "127.0.0.1:30080".

# If you have any problems connecting, this may be caused by a bug in Desktop that causes NodePorts to be inaccessible.

# Try the following workaround:

kubectl port-forward svc/fleetman-webapp 30080:80

# Leave this command running and now "localhost:30080" should be accessible - let me know if you're still stuck.

curl $(minikube ip):30080

kubectl get po n istio-system

# Istio Ingress Gateway

kubectl get svc -n istio-system # get kialy port 


# After open kiali no traffic would be shown in istio-system namespace. this is by default.

# Istio Ingress Gateway

kubectl get svc -n istio-system # get kialy port 


