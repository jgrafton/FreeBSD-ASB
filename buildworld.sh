#!/bin/sh

set -x
set -e 

SVN=/usr/bin/svnlite
DIR=$1

if [ -z "$DIR" ]; then
	echo "$0 [builddir]"
	exit 1
fi

SRCDIR=$DIR/src
OBJDIR=$DIR/obj
NCPU=$(sysctl -n hw.ncpu)

# checkout head if the source repository does not exist
if [ ! -f "${SRCDIR}"/README ]; then
	${SVN} checkout https://svn.freebsd.org/base/head "${SRCDIR}"
fi

export MAKEOBJDIRPREFIX="$OBJDIR"

cd "$SRCDIR"
echo "subversion update..."
date
${SVN} update > "${DIR}"/update.log 2>&1

echo "buildworld..."
date
time make -j "${NCPU}" buildworld > "${DIR}"/buildworld.log 2>&1

echo "buildkernel..."
date
time make buildkernel > "${DIR}"/buildkernel.log 2>&1

