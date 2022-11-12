MACHINECONFIGS = \
	machineconfig.yaml

%.yaml: src/%.bu src/public-ingress.nft src/public-ingress-routes.sh
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
