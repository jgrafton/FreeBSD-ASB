#!/bin/sh

set -x
set -e

export ASSUME_ALWAYS_YES=yes
pkg install devel/kyua
/usr/local/bin/kyua test -k /usr/tests/Kyuafile
