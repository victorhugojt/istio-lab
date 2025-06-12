#!/bin/bash

# Istio Lab Restart Script
# Use this script after rebooting your laptop to quickly restart the lab

set -e

echo "🔄 Restarting Istio Lab after reboot..."

# Step 1: Start minikube (this will restore the previous cluster state)
echo "🚀 Starting minikube..."
minikube start

# Step 2: Wait a moment for the cluster to stabilize
echo "⏳ Waiting for cluster to stabilize..."
sleep 10

# Step 3: Check if Istio is running
echo "🔍 Checking Istio status..."
kubectl get pods -n istio-system

# Step 4: Check if application pods are running
echo "📱 Checking application status..."
kubectl get pods

# Step 5: If pods are not running, they should restart automatically
# But let's give them a moment
echo "⏳ Waiting for pods to restart (this may take a few minutes)..."
kubectl wait --for=condition=ready pod --all -n istio-system --timeout=300s || echo "⚠️  Some Istio components may still be starting..."
kubectl wait --for=condition=ready pod --all --timeout=300s || echo "⚠️  Some application pods may still be starting..."

# Step 6: Verify everything is working
echo ""
echo "✅ Restart completed!"
echo ""
echo "📋 CURRENT STATUS:"
echo "=================="
echo "🔍 Istio Components:"
kubectl get pods -n istio-system

echo ""
echo "📱 Application Pods:"
kubectl get pods

echo ""
echo "🌐 Services:"
kubectl get svc

echo ""
echo "🔗 ACCESS COMMANDS:"
echo "==================="
echo "🌐 Kiali: kubectl port-forward svc/kiali 20001:20001 -n istio-system"
echo "📊 Grafana: kubectl port-forward svc/grafana 3000:3000 -n istio-system"
echo "🔍 Jaeger: kubectl port-forward svc/tracing 16686:80 -n istio-system"
echo "📱 App: kubectl port-forward svc/fleetman-webapp 30080:80"
echo ""
echo "💡 If any components are not ready, wait a few more minutes - they may still be starting."
echo ""
echo "🎉 Istio Lab is ready!" 