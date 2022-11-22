#!/bin/bash

PATCH_DIR="$1"

shopt -s nullglob

mapfile -t patches < <(printf "%s\n" \
    "$PATCH_DIR"/*.patch.yaml \
    "$PATCH_DIR"/*.jsonpatch.yaml \
    "$PATCH_DIR"/*.jsonmerge.yaml | sort)

for patch in "${patches[@]}"; do

    # For strategic merge patches it's possible to infer the target of the patch
    # from the patch itself, but other patch types -- such as JSONPatch patches
    # -- require us to provide an explicit target.
    #
    # The following code replaces the patch type in the filename with "target"
    # (so that "something.patch.yaml" becomes "something.target.yaml"), and
    # if the resulting filename exists it will be used to determine the
    # target of the patch.
    targetname=$(awk -vOFS=. -F. '{$(NF-1) = "target"; print}' <<<"$patch")

    if [[ -f "$targetname" ]]; then
        target=$targetname
    else
        target=$patch
    fi

    case $patch in
        *.patch.yaml)
            patch_type=strategic;;
        *.jsonpatch.yaml)
            patch_type=json;;
        *.mergepatch.yaml)
            patch_type=merge;;

        *)  echo "ERROR: $patch: unknown patch type" >&2
            continue
            ;;
    esac

    echo "Applying $patch"
    if ! kubectl patch -f "$target" --patch-file "$patch" --type "$patch_type"; then
        echo "ERROR: $patch: failed to apply" >&2
    fi
done
