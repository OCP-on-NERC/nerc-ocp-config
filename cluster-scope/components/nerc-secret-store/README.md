# A note about service account tokens

In Kubernetes 1.24 and later, creating a ServiceAccount will no longer automatically create a Secret with an authentication token. This means that using a `serviceAccountRef` when configuring a SecretStore (or ClusterSecretStore) will no longer work, because the external secrets controller will not be able to find an appropriate token from the ServiceAccount.

Instead, we [manually create a service account token][1] and then use a `secretRef` in the SecretStore resource, e.g:

```
auth:
  kubernetes:
    mountPath: kubernetes/nerc-ocp-prod
    role: secret-reader
    secretRef:
      name: "vault-secret-reader"
      key: "token"
```

[1]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-a-service-account-api-token
