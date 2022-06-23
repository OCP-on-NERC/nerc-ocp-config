MACHINECONFIGS = \
	configure-bond0.yaml

%.yaml: src/%.bu
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
