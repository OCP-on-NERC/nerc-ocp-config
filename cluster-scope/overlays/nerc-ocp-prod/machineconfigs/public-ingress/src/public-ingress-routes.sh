#!/bin/bash

device=$1
action=$2

if [[ $device = bond0.2180 ]]; then
        if [[ $action = up ]]; then
            nft -f /etc/nftables/public-ingress.nft
            ip rule add priority 200 fwmark 0x2000/0x2000 lookup 200
            ip route add default via 199.94.61.1 table 200 dev bond0.2180
        elif [[ $action = down ]]; then
            ip rule del priority 200
            nft delete table public-ingress
        fi
fi
