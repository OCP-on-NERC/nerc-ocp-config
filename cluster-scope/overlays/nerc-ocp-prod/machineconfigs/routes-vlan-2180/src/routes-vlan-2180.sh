#!/bin/bash

device=$1
action=$2

if [[ $device = bond0.2180 ]]; then
        if [[ $action = up ]]; then
                ip rule add from 199.94.61.0/24 table 200
                ip route add default via 199.94.61.1 table 200 dev bond0.2180
        elif [[ $action = down ]]; then
                ip rule del from 199.94.61.0/24 table 200
        fi
fi
