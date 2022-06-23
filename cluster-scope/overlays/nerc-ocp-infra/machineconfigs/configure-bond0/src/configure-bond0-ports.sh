#!/bin/bash

mkdir -p /etc/NetworkManager/system-connections-disabled
mv /etc/NetworkManager/system-connections/ens*.nmconnection /etc/NetworkManager/system-connections-disabled/

for path in /etc/mco/$HOSTNAME-nic{1,2}.nmconnection; do
    if [[ -f $path ]]; then
        cp "$path" /etc/NetworkManager/system-connections/ || exit 1
    fi
done

# Ensure correct selinux labels
restorecon /etc/NetworkManager/system-connections
