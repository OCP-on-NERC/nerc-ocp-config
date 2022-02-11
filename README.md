This repository manages Kubernetes manifests deployed on [NERC][] managed
OpenShift clusters.

The directory layout of this repository follows the standards of the
[Operate First][] project (specifically [ADR-0009][]).

[nerc]: https://nerc.mghpcc.org/
[operate first]: https://www.operate-first.cloud/
[adr-0009]: https://github.com/operate-first/blueprint/blob/main/docs/adr/0009-cluster-resources.md

## Validations make your life easier

### Pre-commit checks

Configure linters to run before each commit by install the
`pre-commit` tool:

```
pip install pre-commit
```

And then enabling it for your working directory. From inside this
repository, run:

```
pre-commit install
```
