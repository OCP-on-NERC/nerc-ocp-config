MACHINECONFIGS = \
	bond0-controller.yaml \
	bond0-worker.yaml

%.yaml: src/%.bu $(wildcard src/*.nmconnection)
	butane -o $@ -d src $<

all: $(MACHINECONFIGS)

clean:
	rm -f $(MACHINECONFIGS)
