#!/bin/bash

while true; do

  # watch for new/modified nodes
  kubectl get node -l node-role.kubernetes.io/worker -o name -w | while read NODE_NAME; do
    echo "Checking node: $NODE_NAME"
    PRODUCT=$(kubectl get "$NODE_NAME" -o jsonpath="{.metadata.labels['nvidia\.com/gpu\.product']}")
    if [ -n "$PRODUCT" ]; then
      echo "Found GPU product label: $PRODUCT on $NODE_NAME"
      kubectl taint "$NODE_NAME" "nvidia.com/gpu.product=$PRODUCT:NoSchedule"
    else
      echo "No GPU product label found on node $NODE_NAME, skipping tainting"
    fi
  done

  # watch expired, pause before restarting
  sleep 10
done
