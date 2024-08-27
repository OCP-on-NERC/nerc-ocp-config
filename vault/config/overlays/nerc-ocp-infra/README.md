# NERC Vault Configuration

This repository contains our vault configuration.

Credentials and other secrets are made available by mounting secrets into the configure-vault job, and are inserted into the configuration using the templating features available from the `bank-vaults` cli. There is some documentation on the template language available in "[Using templates for injecting dynamic configuration](https://bank-vaults.dev/docs/operator/templating-configuration/). The configuration files follow the "externalConfiguration" format; you can find examples in the `vault-operator` [`deploy/examples` directory](https://github.com/bank-vaults/vault-operator/tree/main/deploy/examples) (look only at the `externalConfig` section of these files).

The configuration is applied via an ArgoCD [PostSync hook](https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/) when changes are synchronized with the infra cluster.

## Required credentials

The secret `vault-credentials` must be manually created. As of this writing it must contain the following keys:


### Dex client secret

- `dex-client-secret` key is the client secret that permits vault to authenticate against dex.

### Cluster token reviewer tokens

These are tokens for the `eso-vault-auth` serviceAccount configured on each client cluster:

- `hypershift1-token-reviewer`
- `nerc-ocp-obs-token-reviewer`
- `nerc-ocp-prod-token-reviewer`
- `nerc-ocp-test-token-reviewer`

You will need to add a new token for each new cluster.
