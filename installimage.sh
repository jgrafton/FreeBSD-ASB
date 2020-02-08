#!/usr/local/bin/bash

set -x
set -e

DIR=$1

if [ -z $DIR ]; then
	echo "$0 [builddir]"
	exit 1
fi

IMAGE=autobuild.ufs
IMAGE_FILES=${DIR}/image
DESTDIR=/mnt
SRCDIR=${DIR}/src
OBJDIR=${DIR}/obj
export MAKEOBJDIRPREFIX=$OBJDIR

mkdir -p $DESTDIR

# create an image file
truncate -s 8G ${IMAGE}
re=$?
if [ ${re} -ne 0 ]; then
	echo "unable to create an 8G image file"
	exit 1
fi

# TODO: capture actual md device instead of guess it's md0
mdconfig -f ${IMAGE}
re=$?
if [ ${re} -ne 0 ]; then
	echo "unable to create a new md device"
	exit 1
fi

# create a new UFS filesystem on image file
newfs /dev/md0
re=$?
if [ ${re} -ne 0 ]; then
	echo "unable to create new FS on /dev/md0"
	exit 1
fi

mount /dev/md0 /mnt
re=$?
if [ ${re} -ne 0 ]; then
	echo "unable to mount /dev/md0 on /mnt"
	exit 1
fi

cd $SRCDIR

# copy template config files into image
cp -Rpv ${IMAGE_FILES}/* ${DESTDIR}

# install freebsd world and kernel into image
make installworld DESTDIR=${DESTDIR}
make installkernel DESTDIR=${DESTDIR}

# boot using comconsole 
sysrc -f ${DESTDIR}/boot/loader.conf console=comconsole

cd $DIR
umount /mnt
mdconfig -du md0

echo 'building freebsd.img...'
mkimg -s gpt -b /boot/pmbr -p freebsd-boot:=/boot/gptboot -p freebsd-ufs:=${IMAGE} -p freebsd-swap::1G -o freebsd.img
