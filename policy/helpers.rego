package main

# Use this in a rule if you want people to be able to bypass it by adding the
# `nerc.mghpcc.org/allow-policy-violation: "true"` annotation to a manifest.
allowed_by_annotation if {
  input.metadata.annotations["nerc.mghpcc.org/allow-policy-violation"] = "true"
}
