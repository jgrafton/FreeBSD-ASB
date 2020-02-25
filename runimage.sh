#!/bin/sh

set -x
set -e 

IMAGE=freebsd.img
VMNAME=freebsd
CPUS=2
MEM=512M

# destroy old vm if one exists
/usr/sbin/bhyvectl --vm=${VMNAME} --destroy || true

# load new vm
/usr/sbin/bhyveload \
	-c stdio \
	-m ${MEM} \
	-d ${IMAGE} \
	${VMNAME}

# boot new vm into hypervisor
/usr/sbin/bhyve \
	-c ${CPUS} \
	-m ${MEM} \
	-H -A -P \
	-s 0:0,hostbridge \
	-s 1:0,lpc \
	-s 2:0,virtio-net,tap0 \
	-s 3:0,virtio-blk,${IMAGE} \
	-l com1,stdio \
	${VMNAME}

# destroy vm now that it is no longer running
/usr/sbin/bhyvectl --vm=${VMNAME} --destroy
