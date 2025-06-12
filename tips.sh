# Good shutdown practice

minikube stop

kubectl config use-context gke_cv20per-plat-nonprod-product_us-east1_cv20per-plat-nonprod-product--2b

minikube start
kubectl get all                    # Check if resources exist
kubectl get pods -n istio-system   # Check Istio components
kubectl get serviceentry           # Check your ServiceEntry

# if not
sh restart-istio-lab.sh




