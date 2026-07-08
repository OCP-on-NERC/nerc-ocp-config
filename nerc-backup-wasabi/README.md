# nerc-backup-wasabi

Off-site backup of the NERC S3 buckets to Wasabi (us-east-1), directly in the
cluster via rclone CronJobs. Avoids slow external uplinks; runs at datacenter
bandwidth.

## What gets backed up (rclone `copy`, NOT `sync`; keeps deleted objects)
- **nerc-metrics-backup/** from acm-metrics, acm-metrics-hypershift2,
  acm-metrics-test, open-telemetry, open-telemetry-test (each as a prefix).
- **nerc-loki-backup/** from loki-logs, loki-logs-test.
- Target region: Wasabi us-east-1 (s3.wasabisys.com).

## Structure
- `base/namespace.yaml`; namespace `nerc-backup-wasabi`.
- `base/externalsecrets/`; pulls both key pairs from Vault
  (`$ENV/$CLUSTER/loki-thanos-object-storage` for NERC;
  `$ENV/$CLUSTER/wasabi-backup` for Wasabi). The overlay sets the concrete path.
- `base/cronjobs/`; two CronJobs (backup-metrics 02:00, backup-loki 02:30 UTC).
  Each builds the rclone.conf at runtime from the secrets; no static key material.

## Deploy
Via ArgoCD/kustomize like the other components; `overlays/nerc-ocp-obs`
references the base and patches the Vault paths.

## Manual ad-hoc run (outside the schedule)
```sh
oc create job --from=cronjob/backup-metrics backup-metrics-manual -n nerc-backup-wasabi
oc create job --from=cronjob/backup-loki    backup-loki-manual    -n nerc-backup-wasabi
```

## Notes
- loki is a LIVE bucket (audit/ rotates and grows). Use `copy` not `sync`; one
  pass per job (no wrapper loop, otherwise runaway). A 100% snapshot of a live
  loki is not possible; occasional transient 404s are expected.
- rclone `copy` is incremental; a daily run transfers only the delta (metrics
  seconds, loki ~1h, most of it comparing the ~3.3M objects).
- Address Wasabi buckets via the endpoint of THEIR region (mismatch gives 403).
