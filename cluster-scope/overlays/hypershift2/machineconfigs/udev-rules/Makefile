MACHINECONFIGS = \
	custom-udev-rules-controller.yaml \
	custom-udev-rules-worker.yaml

%.yaml: src/%.bu
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
