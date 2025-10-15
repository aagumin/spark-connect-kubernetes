#!/bin/bash

# Define the namespace and pod name where the Istio sidecar is running

# Function to stop the Istio sidecar
stop_istio_sidecar() {
    echo "Stopping Istio sidecar for pod"

    # Send a termination signal to the istio-proxy sidecar
    curl -sf -XPOST 127.0.0.1:15000/quitquitquit

    if [ $? -eq 0 ]; then
        echo "Istio sidecar stopped successfully."
    else
        echo "Failed to stop Istio sidecar."
    fi
}

# Call the function to stop the sidecar
stop_istio_sidecar
