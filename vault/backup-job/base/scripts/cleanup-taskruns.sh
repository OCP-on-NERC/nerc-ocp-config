#!/bin/bash
set -eu

: "${TASKRUN_RETENTION:=10}"

oc get taskrun -l "tekton.dev/task=${TASK_NAME}" --sort-by=.metadata.creationTimestamp -o name | head -n -"${TASKRUN_RETENTION}" |
while read -r TASK_TO_REMOVE; do
  test -n "${TASK_TO_REMOVE}" || continue;
  echo "Deleting taskrun ${TASK_TO_REMOVE}"
  oc delete "${TASK_TO_REMOVE}"
done
