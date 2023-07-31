MACHINECONFIGS = \
	machineconfig-ixgbe.yaml \
	machineconfig-i40e.yaml \
	machineconfig-bcm57412.yaml

%.yaml: src/%.bu
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
