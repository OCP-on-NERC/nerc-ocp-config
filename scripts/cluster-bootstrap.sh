#!/bin/bash

# Run this script from inside a cluster overlay directory. E.g.:
#
#     cd cluster-scope/overlays/nerc-ocp-test
#     bash $(git rev-parse --show-toplevel)/scripts/cluster-bootstrap.sh

if ! [ -f bootstrap/kustomization.yaml ]; then
  echo "missing bootstrap configuration"
  exit 1
fi

set -e

for stage in {1..5}; do
  echo "=== STAGE $stage ==="

  case "$stage" in
  1)
    echo "Applying namespaces, subscriptions, and operatorgroups"
    kustomize build | kfilt -k namespace -k subscription -k operatorgroup | kubectl apply -f- --server-side
    ;;
  2)
    echo "Applying bootstrap secrets"
    kubectl apply -k bootstrap
    ;;
  3)
    echo "Applying {cluster,}issuers and nmstate"
    kustomize build | kfilt -k clusterissuer -k issuer -k nmstate | kubectl apply -f- --server-side
    ;;
  4)
    echo "Applying NNCP, certificates, ingress, oauth, etc"
    kustomize build |
      kfilt -k nodenetworkconfigurationpolicy -k certificate -k ingress -k ingresscontroller -k oauth -k groupsync -k apiserver \
        -l nerc.mghpcc.org/bundle=nerc-ops-rbac |
      kubectl apply -f- --server-side
    ;;

  5)
    echo "Applying everything"
    kubectl apply -k .
    ;;

  *)
    echo "nothing to do"
    ;;
  esac

  echo "Press RETURN to continue"
  read -r _
done
