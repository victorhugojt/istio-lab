minikube delete

minikube start --memory 8192 --cpus 4

# Apply in the order of the files

kubectl apply -f 1-istio-init.yaml

kubectl apply -f 2-istio-namespace.yaml # Tunnig of istio files and ports for jeager and grafana

kubectl apply -f 3-istio-config.yaml

kubectl apply -f 4-istio-telemetry.yaml

# Check if the pods are running
kubectl get pods -n istio-system

# Check if the services are running
kubectl get services -n istio-system

# Check if the pods are running
kubectl get pods -n istio-system

# Check if the services are running

minikube ip

http://$(minikube ip):30080/ # Application

http://192.168.49.2:30080/ # Application

# check Kiali

kubectl get svc -n istio-system

http://$(minikube ip):31000/ # Kiali
http://192.168.49.2:31000/ # Kiali

http://$(minikube ip):31001/ # Jeager
http://192.168.49.2:31001/ # Jeager

http://$(minikube ip):31002/ # Grafana
http://192.168.49.2:31002/ # Grafana




# At this point we do not include any complex istion configs like virtual services, 
# destination rules, etc. Becaus is not for this demo

kubectl get virtualservices

kubectl get destinationrules

kubectl get gateways

kubectl get pods -n istio-system

kubectl get services -n istio-system