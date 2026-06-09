package warnings

generator_has_literals(generator) if {
    "literals" in object.keys(generator)
  some name in generator
  not generator.name == "admin-acks"
}

generator_types := ["configMapGenerator", "secretGenerator"]

# Warn if a configMap- or secretGenerator contains literal values. It is almost
# always better to place values in a file (using `envs:` or `files:`), because
# this makes it easier to lint/syntax-check/etc the data.
warn contains msg if {
    input.kind = "Kustomization"
    some generator_type in generator_types
    some generator in input[generator_type]
    generator_has_literals(generator)
    msg = sprintf("%s '%s' contains a 'literals' stanza", [generator_type, generator.name])
}
