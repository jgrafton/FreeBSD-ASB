#!/bin/sh

DIR=$1

if [ -z $DIR ]; then
	echo "$0 [builddir]"
	exit 1
fi

cd $DIR
./buildworld.sh ${DIR}
./installimage.sh ${DIR}
