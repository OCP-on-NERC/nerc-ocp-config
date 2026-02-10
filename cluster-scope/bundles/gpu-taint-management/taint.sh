#!/bin/bash

# GPU Taint Watcher Script

# Initial tainting of GPU nodes
kubectl get nodes -l node-role.kubernetes.io/worker -o json |
jq -r '
  .items[]
  | select(.metadata.labels["nvidia.com/gpu.product"] != null)
  | .metadata.name + " " + .metadata.labels["nvidia.com/gpu.product"]
' | while read NODE PRODUCT; do
  echo "Initial tainting: $NODE with GPU product $PRODUCT"
  kubectl taint node "$NODE" "nvidia.com/gpu.product=$PRODUCT:NoSchedule" --overwrite=false 2>/dev/null
done

# Declare associative array to track last seen GPU product per node
declare -A LAST_PRODUCT

# Continuous monitoring loop
while true; do
  kubectl get nodes -l node-role.kubernetes.io/worker -o json |
  jq -r '.items[].metadata.name' | while read NODE_NAME; do
    PRODUCT=$(kubectl get node "$NODE_NAME" -o jsonpath="{.metadata.labels['nvidia\.com/gpu\.product']}" 2>/dev/null)

    # Skip nodes without GPU product label
    if [ -z "$PRODUCT" ]; then
      echo "No GPU product label on $NODE_NAME, skipping"
      continue
    fi

    # Check current taints on the node
    CURRENT_TAINT=$(kubectl get node "$NODE_NAME" -o jsonpath="{.spec.taints[?(@.key=='nvidia.com/gpu.product')].value}" 2>/dev/null)

    # Apply taint if label changed or taint is missing
    if [[ "${LAST_PRODUCT[$NODE_NAME]}" != "$PRODUCT" || "$CURRENT_TAINT" != "$PRODUCT" ]]; then
      echo "Applying taint for GPU product '$PRODUCT' on $NODE_NAME (current taint: '${CURRENT_TAINT:-none}')"
      kubectl taint node "$NODE_NAME" "nvidia.com/gpu.product=$PRODUCT:NoSchedule" --overwrite=false 2>/dev/null
      LAST_PRODUCT[$NODE_NAME]="$PRODUCT"
    else
      echo "No change for $NODE_NAME (product: $PRODUCT, taint present)"
    fi
  done

  sleep 30
done
