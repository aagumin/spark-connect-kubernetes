#!/bin/bash

# Function to check if the Istio sidecar is ready
is_sidecar_ready() {
    # Check if the sidecar proxy (Envoy) is running and ready
  curl -s http://localhost:15000/ready | grep "LIVE"
}

# Wait for the sidecar proxy to be ready
echo "Waiting for Istio sidecar to be ready..."
until is_sidecar_ready; do
    echo "Sidecar not ready yet. Waiting..."
    sleep 3
done

echo "Istio sidecar is ready."
