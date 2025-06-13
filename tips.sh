# Good shutdown practice

minikube stop

kubectl config use-context gke_cv20per-plat-nonprod-product_us-east1_cv20per-plat-nonprod-product--2b

minikube start
kubectl get all                    # Check if resources exist
kubectl get pods -n istio-system   # Check Istio components
kubectl get serviceentry           # Check your ServiceEntry

# if not
sh restart-istio-lab.sh

# =====================================
# ISTIO TELEMETRY DASHBOARD ACCESS
# =====================================

# Kiali (Service Mesh Dashboard) - Port 20001
echo "🌐 Starting Kiali port-forward..."
kubectl port-forward svc/kiali 20001:20001 -n istio-system
# Then open: http://localhost:20001

# Grafana (Metrics Dashboards) - Port 3000  
echo "📊 Starting Grafana port-forward..."
kubectl port-forward svc/grafana 3000:3000 -n istio-system
# Then open: http://localhost:3000

# Jaeger (Distributed Tracing) - Port 16686
echo "🔍 Starting Jaeger port-forward..."
kubectl port-forward svc/tracing 16686:80 -n istio-system
# Then open: http://localhost:16686

# Prometheus (Metrics Collection) - Port 9090
echo "📈 Starting Prometheus port-forward..."
kubectl port-forward svc/prometheus 9090:9090 -n istio-system
# Then open: http://localhost:9090

# FleetMan Application - Port 30080
echo "📱 Starting Application port-forward..."
kubectl port-forward svc/fleetman-webapp 30080:80
# Then open: http://localhost:30080

# =====================================
# QUICK ACCESS FUNCTIONS
# =====================================

# Function to start Kiali
start_kiali() {
    echo "🌐 Starting Kiali dashboard..."
    kubectl port-forward svc/kiali 20001:20001 -n istio-system
}

# Function to start Grafana
start_grafana() {
    echo "📊 Starting Grafana dashboard..."
    kubectl port-forward svc/grafana 3000:3000 -n istio-system
}

# Function to start all dashboards in background (requires tmux or multiple terminals)
start_all_dashboards() {
    echo "🚀 Starting all telemetry dashboards..."
    kubectl port-forward svc/kiali 20001:20001 -n istio-system &
    kubectl port-forward svc/grafana 3000:3000 -n istio-system &
    kubectl port-forward svc/tracing 16686:80 -n istio-system &
    kubectl port-forward svc/prometheus 9090:9090 -n istio-system &
    kubectl port-forward svc/fleetman-webapp 30080:80 &
    echo "✅ All dashboards started in background"
    echo "🌐 Kiali: http://localhost:20001"
    echo "📊 Grafana: http://localhost:3000"
    echo "🔍 Jaeger: http://localhost:16686"
    echo "📈 Prometheus: http://localhost:9090"
    echo "📱 App: http://localhost:30080"
}

# Function to stop all port-forwards
stop_all_dashboards() {
    echo "🛑 Stopping all port-forwards..."
    pkill -f "kubectl port-forward"
    echo "✅ All port-forwards stopped"
}

# =====================================

source tips.sh


start_kiali                 # Start just Kiali
start_all_dashboards        # Start all dashboards at once
stop_all_dashboards         # Kill all port-forwards

