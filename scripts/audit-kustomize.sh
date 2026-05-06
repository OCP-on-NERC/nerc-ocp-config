#!/bin/sh
#
# This script finds all yaml files in the repository and then runs 'kustomize build' on every kustomization.yaml file
# in the repository and produces a list of files that were not used in any kustomization.

workdir=$(mktemp -d auditXXXXXX)
trap "rm -rf $workdir" EXIT

# Find a list of all yaml files in the repository
find "$PWD"/* \( -name '*.yaml' -o -name '*.yml' \) -print >"$workdir/all"

# Find a list of all `kustomization.yaml` files in the repository and run
# `kustomize build` on each one. Run this under the control of `strace` and
# log calls to `openat`.
find "$PWD" -name kustomization.yaml -printf "%h\n" |
  strace -o "$workdir/trace" -f -e trace=openat xargs -n1 kustomize build >/dev/null

# Extract filenames from the strace log generated in the previous step.
grep openat "$workdir/trace" | cut -f2 -d'"' | grep $PWD >"$workdir/accessed"

# Output list of unreferenced files to stdout.
grep -Fxv -f "$workdir/accessed" "$workdir/all"
