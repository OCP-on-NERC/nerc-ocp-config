#!/bin/sh

found_common_labels=0
for path in "$@"; do
  if grep -q commonLabels "$path"; then
    echo "commonLabels found in file: $path"
    found_common_labels=1
  fi
done

if [ "$found_common_labels" = 1 ]; then
  echo "'commonLabels' is deprecated. Please use 'labels' instead."
  echo "Run 'kustomize edit fix' to update your Kustomization automatically."
  exit 1
fi
