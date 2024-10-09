MACHINECONFIGS = \
	100-worker-vfiopci.yaml

%.yaml: src/%.bu
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
