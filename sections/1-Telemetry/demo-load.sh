#!/bin/bash

# Smooth Load Generator for Live Istio Demo
# This script generates continuous, smooth traffic perfect for live demonstrations
# of Istio telemetry features (Grafana, Kiali, Jaeger)

# Get minikube IP dynamically
MINIKUBE_IP=$(minikube ip)
BASE_URL="http://${MINIKUBE_IP}:30080"

echo "🚀 Starting smooth demo load generation..."
echo "📍 Target: ${BASE_URL}"
echo "⏱️  Duration: Continuous (press Ctrl+C to stop)"
echo "📊 Pattern: Smooth, gradual traffic suitable for live demos"
echo ""

# Vehicle endpoints for realistic traffic distribution
VEHICLES=(
    "City%20Truck"
    "Huddersfield%20Truck%20A" 
    "Huddersfield%20Truck%20B"
    "London%20Riverside"
    "Village%20Truck"
)

# Function to generate smooth background traffic
generate_smooth_traffic() {
    local vehicle=$1
    local delay=$2
    
    while true; do
        # Single request with realistic user delay
        curl -s "${BASE_URL}/vehicle/${vehicle}" > /dev/null 2>&1
        sleep $delay
    done
}

# Function to generate occasional burst traffic
generate_burst_traffic() {
    while true; do
        # Random vehicle selection
        local vehicle=${VEHICLES[$RANDOM % ${#VEHICLES[@]}]}
        
        # Small burst of 2-4 requests
        local burst_size=$((2 + RANDOM % 3))
        
        echo "💥 Generating small burst: ${burst_size} requests to ${vehicle//\%20/ }"
        
        for ((i=1; i<=burst_size; i++)); do
            curl -s "${BASE_URL}/vehicle/${vehicle}" > /dev/null 2>&1 &
            sleep 0.5
        done
        
        # Wait 15-30 seconds before next burst
        sleep $((15 + RANDOM % 16))
    done
}

# Trap Ctrl+C to clean up background processes
cleanup() {
    echo ""
    echo "🛑 Stopping demo load generation..."
    kill $(jobs -p) 2>/dev/null
    echo "✅ All background processes stopped."
    exit 0
}

trap cleanup SIGINT

# Start smooth continuous traffic for each vehicle
echo "🔄 Starting continuous smooth traffic..."
for i in "${!VEHICLES[@]}"; do
    vehicle="${VEHICLES[$i]}"
    # Stagger delays: 3, 4, 5, 6, 7 seconds for different vehicles
    delay=$((3 + i))
    
    echo "  📡 Starting traffic to ${vehicle//\%20/ } (every ${delay}s)"
    generate_smooth_traffic "$vehicle" $delay &
done

# Start occasional burst traffic
echo "💥 Starting occasional burst traffic..."
generate_burst_traffic &

# Keep script running and show activity
echo ""
echo "📈 Demo load is now running smoothly!"
echo "   - Continuous requests every 3-7 seconds per vehicle"
echo "   - Occasional small bursts every 15-30 seconds"
echo "   - Perfect for observing Istio telemetry in real-time"
echo ""
echo "🖥️  Open your telemetry dashboards:"
echo "   Grafana:  ${BASE_URL//:30080/:31002}/"
echo "   Kiali:    ${BASE_URL//:30080/:31000}/"
echo "   Jaeger:   ${BASE_URL//:30080/:31001}/"
echo ""
echo "Press Ctrl+C to stop..."

# Show periodic stats
counter=0
while true; do
    sleep 10
    counter=$((counter + 10))
    echo "⏱️  Demo load running for ${counter} seconds..."
done
