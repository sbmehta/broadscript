#!/bin/bash

# run as sudo -u username provision_samar.sh

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif [[ -f /etc/lsb-release ]]; then
    OS=$(lsb_release si)
    VER=$(lsb_release -sr)
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo Configuring my environment for: $OS:$VER


shopt -s nocasematch


if [[ $OS =~ debian ]]; then
    echo "Found Debian!"
elif [[ $OS =~ ubuntu ]]; then
    echo "Found Ubuntu!"
fi

exit 0

apt update && apt upgrade
