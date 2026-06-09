#!/bin/sh

docker run --rm -v "$PWD:/project" openpolicyagent/conftest test \
  --all-namespaces \
  --ignore '\.venv|/charts/' \
  .
