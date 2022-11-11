MACHINECONFIGS = \
	machineconfig.yaml

%.yaml: src/%.bu src/rpfilter.conf
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
