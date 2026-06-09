#!/bin/sh

IGNOREFILE=.policyignore
IGNOREFILE_LOCAL=.policyignore.local

find . \( -name '*.yaml' -o -name '*.yml' \) -print0 |
  if [ -f "$IGNOREFILE" ]; then grep -zvFf "$IGNOREFILE"; else cat; fi |
  if [ -f "$IGNOREFILE_LOCAL" ]; then grep -zvFf "$IGNOREFILE_LOCAL"; else cat; fi |
  xargs -0 docker run --rm -v "$PWD:/project" openpolicyagent/conftest test \
    --all-namespaces
