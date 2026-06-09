package main

# Reject secrets (other than those used to create long-lived service account
# tokens). Secrets should not be included in the repository.
deny contains msg if {
    input.kind = "Secret"
  not allowed_by_annotation
  not input.metadata.annotations["kubernetes.io/service-account.name"]
    msg = "Do not include secrets in the repository"
}
