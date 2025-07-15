#!/bin/bash
set -ex

#export QUAY_USERNAME='weka.io+weka_access_orion'
#export QUAY_PASSWORD='ZMOS1WI7ZQ8THR2O622L2KSU9XKXZY14RD8AAECJOELT8RGLX3AYU7OOIO9P2R35'
#
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
   --set ocpCompatibility.hugepageConfiguration.hugepagesCount=4000
