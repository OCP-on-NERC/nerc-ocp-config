MACHINECONFIGS = \
	machineconfig-ixgbe.yaml \
	machineconfig-i40e.yaml

%.yaml: src/%.bu
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
