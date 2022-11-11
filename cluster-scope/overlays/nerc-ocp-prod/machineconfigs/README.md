Including file content in ignition configs is a pain, because it has to be base64 encoded. The `Makefiles` in in these directories uses [Butane][] to transpile `MachineConfig` resources, automatically including and encoding content from files.

Read "[Creating machine configs with Butane][]" in the [OpenShift documentation][] for more information.

[butane]: https://coreos.github.io/butane/
[openshift documentation]: https://docs.openshift.com/container-platform/4.10/installing/install_config/installing-customizing.html
[creating machine configs with butane]: https://docs.openshift.com/container-platform/4.10/installing/install_config/installing-customizing.html#installation-special-config-butane_installing-customizing
