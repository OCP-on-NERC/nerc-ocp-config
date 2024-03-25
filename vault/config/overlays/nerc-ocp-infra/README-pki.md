## List certificates

```
vault list pki-nerc-root/certs
```

This will return a list of certificate serial numbers. If you would like to see e.g. the CN along with serial number, you could do something like this:

```
for cert in $(vault list -format json pki-nerc-root/certs | jq -r '.[]'); do
    echo -n "$cert "
    vault read -field certificate pki-nerc-root/cert/$cert | openssl x509 -noout -subject
done
```

## Get certificate details

```
vault read pki-nerc-root/cert/<serial>
```

This will show information about the given certificate. To retrieve just the PEM-encoded certificate itself, you can run:

```
vault read -field certificate pki-nerc-root/cert/<serial>
```

Or to retrieve the information in JSON format:

```
vault read -format json pki-nerc-root/cert/<serial>
```

## Issue a certificate

To issue a new certificate:

```
vault write -format json pki-nerc-root/issue/default \
  common_name="api.nerc-ocp-test.rc.fas.harvard.edu" > crt.json
```

If you need to issue a wildcard certificate, you can specify `alt_names` on the command line:

```
vault write -format json pki-nerc-root/issue/default \
  common_name="api.nerc-ocp-test.rc.fas.harvard.edu" \
  alt_names="*.apps.nerc-ocp-test.rc.fas.harvard.edu"  > crt.json
```

It is *critical* that you save the output, because you will not be ablw to retrieve the private key after the certificate has been generated.

## Revoke a certificate

To revoke a certificate:

```
vault write pki-nerc-root/revoke serial_number=<serial>
```

But note that due to the way certificates operate, **a revoked certificate is still valid** unless the connecting agent explicitly checks the CRL endpoint.
