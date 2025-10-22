#!/bin/bash
set -ex

#kubectl create ns weka-operator-system --as=system:admin
#
#kubectl create --as=system:admin secret docker-registry weka-quayio-creds \
#  --docker-server=quay.io \
#  --docker-username=$QUAY_USERNAME \
#  --docker-password=$QUAY_PASSWORD \
#  --docker-email=$QUAY_USERNAME \
#  --namespace=weka-operator-system


#helm upgrade --install weka-operator oci://quay.io/weka.io/helm/weka-operator \
#   --namespace weka-operator-system \
#   --version v1.6.2 \
#   --set nodeAgent.persistencePaths=/root/k8s-weka \
#   --set ocpCompatibility.hugepageConfiguration.enabled=true \
#   --set ocpCompatibility.hugepageConfiguration.hugepagesCount=4000 \
#   --set debugSleep=3600

helm upgrade --install weka-operator oci://quay.io/weka.io/helm/weka-operator \
   --namespace weka-operator-system \
   --version v1.7.0 \
   --set nodeAgent.persistencePaths=/root/k8s-weka \
   --set ocpCompatibility.hugepageConfiguration.enabled=true \
   --set ocpCompatibility.hugepageConfiguration.hugepagesCount=4000 \
   --set csi.installationEnabled=true
