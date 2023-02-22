This is necessary to work around an apparent issue with routes to the API server.

We have tried to expose the API externally by adding a route to the `openshift-kube-apiserver` namespace:

```
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: api-external
  namespace: openshift-kube-apiserver
  labels:
    nerc.mghpcc.org/external-ingress: "true"
spec:
  host: api.apps.shift.nerc.mghpcc.org
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: reencrypt
  to:
    kind: Service
    name: apiserver
  port:
    targetPort: https
```

Unfortunately, with this route in place, attempts to access `https://api.apps.shift.nerc.mghpcc.org`  fail with the "Application is not available" message.
