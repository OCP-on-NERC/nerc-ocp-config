#!/bin/bash

custom_dns_port=8053
custom_dns_addr=$(oc -n custom-dns get svc custom-dns -o jsonpath='{.spec.clusterIP}')
if [[ -z "$custom_dns_addr" ]]; then
  echo "ERROR: unable to determine custom dns server address" >&2
  exit 1
fi

echo "setting custom dns server to ${custom_dns_addr}:${custom_dns_port}"

cat >/tmp/dns.patch <<EOF
apiVersion: operator.openshift.io/v1
kind: DNS
metadata:
  name: default
spec:
  servers:
  - name: nerc-ocp-infra
    zones:
    - nerc-ocp-infra.rc.fas.harvard.edu
    forwardPlugin:
      policy: Random
      upstreams:
      - ${custom_dns_addr}:${custom_dns_port}
EOF

oc patch dns.operator default --patch-file /tmp/dns.patch --type merge
