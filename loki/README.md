# Loki Configuration

This directory contains the LokiStack configuration for log aggregation and storage.

## Storage Schema Configuration

When you configure LokiStack instances, always include explicit storage schema versioning to prevent operator warnings:

```yaml
storage:
  schemas:
  - effectiveDate: '2020-10-11'
    version: v11
  - effectiveDate: '2025-11-01'
    version: v12
  - effectiveDate: '2025-11-15'
    version: v13
```

### Best Practices

- **Gradual migration**: Upgrade schemas incrementally (v11 → v12 → v13)
- **Future dates**: Set effectiveDate in the future (minimum 3-7 days between versions)
- **Multiple schemas**: Keep all schema versions to prevent data loss
- **Spacing**: Allow 1-2 weeks between schema upgrades for safe migration
- **Version v13**: Latest recommended schema version for OpenShift Logging 6.x
- **Operator warnings**: Explicit schema configuration prevents "LokistackSchemaUpgradesRequired" alerts

### Key Points

- **v11** = Legacy schema version (existing data compatibility)
- **v12** = Intermediate schema version (migration step)
- **v13** = Latest schema version (recommended target)
- **effectiveDate** = Date in UTC when schema becomes active (format: 'YYYY-MM-DD')
- **Future dates only** = Cannot add schemas with past dates to running LokiStack
- **Irreversible** = Schema changes cannot be undone; plan carefully

## References

### Official Documentation

- **[Loki Operator - LokistackSchemaUpgradesRequired Alert](https://loki-operator.dev/docs/sop.md/)** - Standard Operating Procedures for the schema upgrade warning
- **[Grafana Loki - Storage Schema](https://grafana.com/docs/loki/latest/operations/storage/schema/)** - How schema versions work, timing, and best practices
- **[Red Hat OpenShift Logging 6.3 - Configuring LokiStack Storage](https://docs.redhat.com/en/documentation/red_hat_openshift_logging/6.3/html/configuring_logging/configuring-lokistack-storage)** - Official Red Hat documentation for v12 to v13 migration
- **[Grafana Loki Operator API](https://github.com/grafana/loki/blob/main/operator/docs/operator/api.md)** - API reference for ObjectStorageSchema configuration
- **[Red Hat Solution 7063482](https://access.redhat.com/solutions/7063482)** - LokistackSchemaUpgradesRequired warning resolution (requires subscription)

### Community Resources

- **[OpenShift Logging: A Quickstart Guide with Loki Stack](https://www.opensourcerers.org/2025/07/21/openshift-logging-a-quickstart-guide-with-loki-stack/)** - Recent practical example with schema configuration

## Overlays

- `nerc-ocp-obs`: Observability cluster with 90-day retention for audit logs
