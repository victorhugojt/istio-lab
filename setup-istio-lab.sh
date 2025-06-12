#!/bin/bash

# Istio Lab Setup Script
# This script sets up a complete Istio service mesh environment from scratch

set -e  # Exit on any error

echo "🚀 Starting Istio Lab Setup..."

# Step 1: Clean up any existing minikube cluster
echo "🧹 Cleaning up existing minikube cluster..."
minikube delete || true

# Step 2: Start minikube with sufficient resources for Istio
echo "🔧 Starting minikube with Istio-compatible resources (8GB RAM, 4 CPUs)..."
minikube start --memory 8192 --cpus 4

# Step 3: Download and install Istio
echo "📥 Downloading Istio..."
curl -L https://istio.io/downloadIstio | sh -

# Find the Istio directory (it will be istio-<version>)
ISTIO_DIR=$(find . -maxdepth 1 -name "istio-*" -type d | head -1)
if [ -z "$ISTIO_DIR" ]; then
    echo "❌ Failed to find Istio directory"
    exit 1
fi

echo "✅ Found Istio directory: $ISTIO_DIR"

# Step 4: Add istioctl to PATH for this session
export PATH="$PATH:$(pwd)/$ISTIO_DIR/bin"

# Step 5: Run Istio pre-installation check
echo "🔍 Running Istio pre-installation check..."
istioctl x precheck

# Step 6: Install Istio
echo "⛵ Installing Istio control plane..."
istioctl install --set values.defaultRevision=default -y

# Step 7: Install telemetry addons (Kiali, Jaeger, Grafana, Prometheus, Loki)
echo "📊 Installing Istio telemetry addons..."
kubectl apply -f $ISTIO_DIR/samples/addons/

# Step 8: Enable sidecar injection for default namespace
echo "💉 Enabling Istio sidecar injection for default namespace..."
kubectl label namespace default istio-injection=enabled

# Step 9: Fix API versions in the application YAML file
echo "🔧 Updating API versions in application YAML..."
if [ -f "sections/warmup-exercise/4-application-full-stack.yaml" ]; then
    # Update v1alpha3 to v1 for all Istio networking resources
    sed -i.bak 's/networking\.istio\.io\/v1alpha3/networking.istio.io\/v1/g' sections/warmup-exercise/4-application-full-stack.yaml
    echo "✅ Updated API versions in 4-application-full-stack.yaml"
else
    echo "⚠️  Warning: sections/warmup-exercise/4-application-full-stack.yaml not found"
fi

# Step 10: Apply the application
echo "🚀 Deploying the application..."
if [ -f "sections/warmup-exercise/4-application-full-stack.yaml" ]; then
    kubectl apply -f sections/warmup-exercise/4-application-full-stack.yaml
else
    echo "⚠️  Skipping application deployment - YAML file not found"
fi

# Step 11: Wait for pods to be ready
echo "⏳ Waiting for application pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=300s || echo "⚠️  Some pods may still be starting..."

# Step 12: Wait for telemetry components to be ready
echo "⏳ Waiting for telemetry components to be ready..."
kubectl wait --for=condition=ready pod --all -n istio-system --timeout=300s || echo "⚠️  Some telemetry components may still be starting..."

# Step 13: Display status and access information
echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 STATUS CHECK:"
echo "=================="
echo "🔍 Istio Control Plane:"
kubectl get pods -n istio-system

echo ""
echo "📱 Application Pods:"
kubectl get pods

echo ""
echo "🌐 Services:"
kubectl get svc

echo ""
echo "🔗 ACCESS INFORMATION:"
echo "======================"
echo "To access the telemetry dashboards, use these commands:"
echo ""
echo "🌐 Kiali (Service Mesh Dashboard):"
echo "   kubectl port-forward svc/kiali 20001:20001 -n istio-system"
echo "   Then open: http://localhost:20001"
echo ""
echo "📊 Grafana (Metrics Dashboards):"
echo "   kubectl port-forward svc/grafana 3000:3000 -n istio-system"
echo "   Then open: http://localhost:3000"
echo ""
echo "🔍 Jaeger (Distributed Tracing):"
echo "   kubectl port-forward svc/tracing 16686:80 -n istio-system"
echo "   Then open: http://localhost:16686"
echo ""
echo "📈 Prometheus (Metrics):"
echo "   kubectl port-forward svc/prometheus 9090:9090 -n istio-system"
echo "   Then open: http://localhost:9090"
echo ""
echo "📱 Application (FleetMan WebApp):"
echo "   kubectl port-forward svc/fleetman-webapp 30080:80"
echo "   Then open: http://localhost:30080"
echo ""
echo "🔧 TROUBLESHOOTING:"
echo "==================="
echo "• Check Istio injection: kubectl describe ns default"
echo "• View pod logs: kubectl logs <pod-name> -c istio-proxy"
echo "• Check ServiceEntry: kubectl get serviceentry"
echo "• Check VirtualService: kubectl get virtualservice"
echo "• Check DestinationRule: kubectl get destinationrule"
echo ""
echo "💡 TIP: Add this to your ~/.bashrc or ~/.zshrc for permanent istioctl access:"
echo "   export PATH=\"\$PATH:$(pwd)/$ISTIO_DIR/bin\""
echo ""
echo "✅ Istio Lab is ready to use!" 