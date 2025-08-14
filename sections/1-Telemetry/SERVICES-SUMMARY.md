# Kubernetes Services in Istio Telemetry Lab

## Overview
This document provides a comprehensive summary of all Kubernetes services deployed in the `sections/1-Telemetry` directory of the Istio lab environment.

## 🔧 Istio Core Services
*Deployed in `istio-system` namespace*

| Service Name | Type | Ports | Purpose |
|--------------|------|-------|---------|
| **istio-ingressgateway** | NodePort | `80` (→31380), `443`, `31400`, `15021` | External traffic entry point to the mesh |
| **istio-egressgateway** | ClusterIP | `80` (→8080), `443` (→8443) | External traffic exit point from the mesh |
| **istiod** | ClusterIP | `15010`, `15011`, `15012` | Istio control plane (Pilot, Citadel, Galley) |

## 📊 Telemetry & Observability Services
*Deployed in `istio-system` namespace*

| Service Name | Type | Internal Port | NodePort | External Access |
|--------------|------|---------------|----------|-----------------|
| **prometheus** | ClusterIP | `9090` | - | Internal only |
| **grafana** | NodePort | `3000` | `31002` | `http://<minikube-ip>:31002` |
| **kiali** | NodePort | `20001`, `9090` | `31000` | `http://<minikube-ip>:31000` |
| **tracing** (Jaeger UI) | NodePort | `80` (→16686) | `31001` | `http://<minikube-ip>:31001` |
| **zipkin** | ClusterIP | `9411` | - | Internal (Istio trace collection) |
| **jaeger-collector** | ClusterIP | `14268`, `14250`, `9411` | - | Internal trace collection |

## 🚢 Application Services (FleetMan)
*Deployed in `default` namespace*

| Service Name | Type | Port | NodePort | Purpose |
|--------------|------|------|----------|---------|
| **fleetman-webapp** | NodePort | `80` | `30080` | Web UI Frontend |
| **fleetman-position-tracker** | ClusterIP | `8080` | - | GPS position tracking service |
| **fleetman-api-gateway** | ClusterIP | `8080` | - | API Gateway/Backend for Frontend |
| **fleetman-vehicle-telemetry** | ClusterIP | `8080` | - | Vehicle telemetry data service |
| **fleetman-staff-service** | ClusterIP | `8080` | - | Staff management service |

## 🌐 External Access Points

### Quick Access Commands
```bash
# Get minikube IP
minikube ip

# Application Access
http://$(minikube ip):30080/    # FleetMan Web Application

# Telemetry Dashboards
http://$(minikube ip):31000/    # Kiali (Service Mesh Observability)
http://$(minikube ip):31001/    # Jaeger (Distributed Tracing)
http://$(minikube ip):31002/    # Grafana (Metrics Dashboards)
```

### Port-Forward Alternative (Recommended)
```bash
# For more reliable access
kubectl port-forward svc/kiali 20001:20001 -n istio-system        # Kiali
kubectl port-forward svc/grafana 3000:3000 -n istio-system        # Grafana  
kubectl port-forward svc/tracing 16686:80 -n istio-system         # Jaeger
kubectl port-forward svc/fleetman-webapp 30080:80                 # App
```

## 🔍 Data Persistence Configuration

| Component | Storage Type | Persistent? | Data Retention |
|-----------|--------------|-------------|----------------|
| **Prometheus** | `emptyDir` | ❌ No | Lost on pod restart |
| **Jaeger** | `emptyDir` (Badger DB) | ❌ No | Lost on pod restart |
| **Grafana** | `emptyDir` | ❌ No | Lost on pod restart |

> **Note**: This is a learning/demo environment. All telemetry data is stored in temporary volumes and will be lost when pods restart.

## 📋 Summary Statistics

- **Total Services**: 11
- **External Access Services**: 4 (via NodePort)
- **Internal Services**: 7 (ClusterIP only)
- **Namespaces Used**: 2 (`istio-system`, `default`)
- **Istio Components**: 3 core services
- **Telemetry Stack**: 4 observability tools
- **Sample Application**: 5 microservices

## 🎯 Lab Purpose

This configuration creates a complete Istio service mesh environment with:
- ✅ Full observability stack (metrics, tracing, visualization)
- ✅ Sample microservices application for testing
- ✅ Easy external access via NodePort services
- ✅ Non-persistent storage for clean lab resets

Perfect for learning Istio service mesh concepts, traffic management, and observability features without the complexity of production-grade persistence and storage management.

## 🚀 Quick Start Commands

```bash
# Deploy the telemetry lab
cd sections/1-Telemetry
sh telemetry.sh

# Check all services
kubectl get svc -n istio-system
kubectl get svc -n default

# Access dashboards
minikube ip  # Get the IP first
# Then visit the URLs above with your minikube IP
```

---
*Generated: $(date)*
*Location: `sections/1-Telemetry/SERVICES-SUMMARY.md`*
