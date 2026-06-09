package main

# The `commonLabels` directive has been depreacted since Kustomize v5.0.0,
# released in 2023. Use of this directive causes kustomize to emit warnings for
# every impacted kustomization.yaml file.
deny contains msg if {
    input.kind = "Kustomization"
    "commonLabels" in object.keys(input)
    msg = "The commonLabels directives has been deprecated. Please use the 'labels' directive."
}
