all: vault-operator.yaml

# Generate manifests from the helm chart using `kustomize build --enable-helm`.
vault-operator.yaml: $(wildcard src/*)
	kustomize build --enable-helm src > $@ || { rm -f $@; exit 1; }

clean:
	rm -f vault-operator.yaml
