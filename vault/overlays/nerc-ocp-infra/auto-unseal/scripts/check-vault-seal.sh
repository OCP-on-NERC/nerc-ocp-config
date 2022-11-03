#!/bin/bash
set -ue

oc exec -i nerc-vault-0 -- vault status --format=json > /tmp/sealed.json
sealed=$(yq -r '.sealed')
echo "$sealed"
