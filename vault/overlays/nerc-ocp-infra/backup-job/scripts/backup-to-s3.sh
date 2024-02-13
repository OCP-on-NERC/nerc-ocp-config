#!/bin/bash
set -eu

: "${S3_RETENTION:=10d}"
: "${PVC_RETENTION:=2d}"

echo "Setting up mc connection to S3 Bucket"
mc alias set store "${ENDPOINT}" "${ACCESS_KEY_ID}" "${SECRET_ACCESS_KEY}" --api S3v4

echo "Syncing contents of ${SNAPSHOT_PATH}/ to Bucket ${BUCKET} that are newer than ${S3_RETENTION}"
mc mirror "${SNAPSHOT_PATH}/" "store/${BUCKET}/vault/" --newer-than "${S3_RETENTION}"

echo "Removing files from Bucket ${BUCKET} that are older than ${S3_RETENTION}"

mc rm -r --force --older-than "${S3_RETENTION}" "store/${BUCKET}/vault"

echo "Listing remote snapshots in ${BUCKET}/vault"

echo --------------------------------------------
mc ls "store/${BUCKET}/vault/"
echo --------------------------------------------

echo "Removing files from PVC that are older than ${PVC_RETENTION} in path ${SNAPSHOT_PATH}"
mc rm -r --force --older-than "${PVC_RETENTION}" "${SNAPSHOT_PATH}/"

echo "Listing local snapshots in ${SNAPSHOT_PATH}"

echo --------------------------------------------
ls "${SNAPSHOT_PATH}" -lha
echo --------------------------------------------

echo "Done!"
