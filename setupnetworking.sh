#!/bin/sh

set -x
set -e

IF=re0

sysctl net.link.tap.up_on_open=1

# create virtual interface
ifconfig tap0 create || true
ifconfig bridge0 create || true

# add virtual interface to bridge
ifconfig bridge0 addm ${IF} addm tap0 || true

# bring interfaces online
ifconfig tap0 up
ifconfig bridge0 up
