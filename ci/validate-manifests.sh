#!/bin/bash

: "${KUSTOMIZE:=kustomize}"

find_overlays() {
    find . -regex '.*/overlays/[^/]*/kustomization.yaml' -exec dirname {} \;
}

okay() {
    echo -n "$(tput setaf 2)${1}:okay$(tput sgr0) "
}

fail() {
    echo "$(tput setaf 1)${1}:failed$(tput sgr0)"
    [[ -s "$tmpdir/stdout" ]] && { echo; cat $tmpdir/stdout; }
    [[ -s "$tmpdir/stderr" ]] && { echo; cat $tmpdir/stderr; }
    exit 1
}

tmpdir=$(mktemp -d buildXXXXXX)
trap "rm -rf $tmpdir" EXIT

for overlay in $(find_overlays); do
    : > "$tmpdir/stdout"

    echo -n "$overlay "
    if $KUSTOMIZE build "$overlay" > "$tmpdir/manifests.yaml" 2> "$tmpdir/stderr"; then
        okay build
    else
        fail build
    fi

    echo
done
