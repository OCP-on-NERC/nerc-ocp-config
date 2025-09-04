#!/bin/bash

# Initialize and taint any GPU nodes at runtime
kubectl get nodes -l node-role.kubernetes.io/worker -o json |
  jq -r '
    .items[]
    | select(.metadata.labels["nvidia.com/gpu.product"] != null)
    | .metadata.name + " " + .metadata.labels["nvidia.com/gpu.product"]
  ' |
while read NODE PRODUCT; do
    echo "Tainting existing $NODE with $PRODUCT"
    kubectl taint node "$NODE" "nvidia.com/gpu.product=$PRODUCT:NoSchedule" --overwrite=false
done

declare -A LAST_PRODUCT

while true; do
  kubectl get node -l node-role.kubernetes.io/worker -o name -w | while read NODE_NAME; do
    echo "Checking node: $NODE_NAME"
    PRODUCT=$(kubectl get "$NODE_NAME" -o jsonpath="{.metadata.labels['nvidia\.com/gpu\.product']}")

    # Compare to stored LAST_PRODUCT, only taint if the the nvidia.com/gpu.product value changes
    if [[ "${LAST_PRODUCT[$NODE_NAME]}" != "$PRODUCT" ]]; then
      if [ -n "$PRODUCT" ]; then
        echo "GPU product label changed to '$PRODUCT' on $NODE_NAME, applying taint"
        kubectl taint node "$NODE_NAME" "nvidia.com/gpu.product=$PRODUCT:NoSchedule" --overwrite=false
      else
        echo "GPU product label removed from $NODE_NAME skipping tainting"
      fi
      LAST_PRODUCT[$NODE_NAME]="$PRODUCT"
    else
      echo "No change in GPU product label for $NODE_NAME (still '${PRODUCT:-unset}'), skipping"
    fi
  done
  # watch expired, pause before restarting
  sleep 10
done
