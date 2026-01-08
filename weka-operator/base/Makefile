all: weka-operator.yaml

# Generate manifests from the helm chart using `kustomize build --enable-helm`.
weka-operator.yaml: $(wildcard src/*)
	kustomize build --enable-helm src > $@ || { rm -f $@; exit 1; }

clean:
	rm -f weka-operator.yaml
