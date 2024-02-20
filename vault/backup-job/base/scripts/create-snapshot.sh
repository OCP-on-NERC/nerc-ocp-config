#!/bin/sh
set -eu

snapshot_file_name=$(date +"snapshot-%F_T%H-%M-%S.snap")

# Grab jwt token from the backup-job serviceaccount, and make the vault token request using k8s login method
VAULT_TOKEN=$(vault write -field=token auth/kubernetes/backup/login role=nerc-vault-backup jwt="$(cat /run/secrets/kubernetes.io/serviceaccount/token)")
export VAULT_TOKEN

vault operator raft snapshot save "${SNAPSHOT_PATH}/${snapshot_file_name}"
echo "Backup Snapshot saved at ${SNAPSHOT_PATH}/$snapshot_file_name"

echo Listing current snapshots in backedup PVC
echo --------------------------------------------
ls -lh "${SNAPSHOT_PATH}"
echo --------------------------------------------

echo "Done!"
