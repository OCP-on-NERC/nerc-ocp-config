# Why is this OpenAPI schema here?

Many kubernetes resources include lists of objects, such the
`spec.containers` field of Pods:

    spec:
      containers:
        - name: container1
          image: example
        - name: container2
          image: example

Kustomize is able to apply a strategic merge patch to specific
elements in this list by matching the patch against a "merge key".
That is, if we want to add an `env` attribute to `container2`, we can
create a patch like this:

    apiVersion: v1
    kind: Pod
    metadata:
      name: example
    spec:
      containers:
        - name: container2
          env:
            - MYVAR=somevalue

Kustomize "knows" to patch the list item with `name` equal to
`container2` because it has a compiled in schema for native kubernetes
resources that identifies the appropriate merge keys (the `name`
field). We end up with:

    spec:
      containers:
        - name: container1
          image: example
        - name: container2
          image: example
          env:
            - MYVAR=somevalue

This won't work by default for custom resource types. For example, if
we have a resource like this:

    apiVersion: multicluster.openshift.io/v1
    kind: MultiClusterEngine
    metadata:
      name: multiclusterengine
    spec:
      overrides:
        components:
        - enabled: true
          name: local-cluster
        - enabled: true
          name: assisted-service
        - enabled: false
          name: hypershift-preview

And we try to modify it with a patch like this:

    apiVersion: multicluster.openshift.io/v1
    kind: MultiClusterEngine
    metadata:
      name: multiclusterengine
    spec:
      overrides:
        components:
        - enabled: true
          name: hypershift-preview

We will see that rather than making the expected change (setting
`enabled` to `true` for the list item with `name:
hypershift-preview`), this will simply *replace* the entire content of
the `components` key.

It is possible to provide Kustomize with a custom openapi schema that
informs of it of the appropriate merge keys for this sort of custom
resource. There is documentation and an example at [1], but
unfortunately this example is misleading. After reading that document
you may believe that you can provide a schema specific to the custom
resources you want to patch, but that is not the case: a custom schema
*completely replaces* the compiled-in schema, so for example with the
configuration shown in that example, Kustomize would no longer be able
to correctly patch containers in Pods and Deployments. This problem is
more fully discussed in [2], and there is some discussion in
kubernetes/kubernetes#82942 and kubernetes-sigs/kustomize#4613.

[1]: https://github.com/kubernetes-sigs/kustomize/blob/master/examples/customOpenAPIschema.md
[2]: https://blog.argoproj.io/argo-crds-and-kustomize-the-problem-of-patching-lists-5cfc43da288c

Strategic merge patches are the only way to patch lists by
object id, rather than by index, so it's functionality we need. To
support this, that means we need to dump the complete openapi schema
from our clusters to a file and make that available to Kustomize. This
commit introduces an initial version of this schema, but we will need
to update this in the future whenever we want to patch CRDs that
weren't available at the time we last generated this schema dump.
