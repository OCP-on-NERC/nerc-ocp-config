# Logging Overlays

## Adding a New Cluster

When adding logging configuration for a new cluster that forwards to Loki:

### 1. Create overlay directory structure

```bash
mkdir -p logging/overlays/<new-cluster-name>/clusterlogforwarders
mkdir -p logging/overlays/<new-cluster-name>/externalsecrets
```

### 2. Copy template from existing cluster

```bash
cp -r logging/overlays/nerc-ocp-prod/* logging/overlays/<new-cluster-name>/
```

### 3. Update cluster-specific values

Edit `clusterlogforwarders/instance_patch.yaml`:
- Update Loki endpoint URLs (if different)
- **Keep the label drops** in all three pipelines

Edit `externalsecrets/openshift-logging-lokistack-gateway-bearer-token_patch.yaml`:
- Update Vault secret path

### 4. IMPORTANT: High-Cardinality Label Drops

**Always include these label drops in each pipeline** to prevent S3 object explosion:

```yaml
labels:
  kubernetes_pod_name: ""
  kubernetes_pod_id: ""
  kubernetes_container_id: ""
```

**Why:** These labels create millions of log streams (one per pod instance), resulting in
millions of small S3 objects. See https://github.com/nerc-project/operations/issues/1410

**Impact without label drops:**
- 3.4M+ S3 objects in 90 days
- Exceeds OpenStack Object Store quotas
- High S3 storage costs

**Impact with label drops:**
- 90%+ reduction in S3 object count
- 95%+ reduction in active Loki streams
- Pod names remain searchable in log message content

### 5. Validation

```bash
kustomize build logging/overlays/<new-cluster-name>
```

## Architecture Note

Cluster overlays **fully replace** the base `ClusterLogForwarder` spec because each cluster
has different outputs (Loki endpoints). Therefore, shared configuration like label drops
cannot be defined in a component or base patch - they must be included in each cluster's
`instance_patch.yaml` file.

### Why Not Use Kustomize Components?

Components are applied **before** overlay patches in the kustomization pipeline. Since the
ClusterLogForwarder resource with cluster-specific outputs is created by the overlay patch
(not inherited from base), any component trying to patch it would fail with "no matches"
because the resource doesn't exist yet at component application time.

**Kustomize processing order:**
1. Load base resources
2. Apply components (ClusterLogForwarder doesn't have send-app-logs pipeline yet)
3. Apply overlay patches (ClusterLogForwarder spec is fully replaced here)

This is why label drops must be included directly in each overlay's instance_patch.yaml.
