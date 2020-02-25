#!/bin/sh

set -x
set -e

export ASSUME_ALWAYS_YES=yes
pkg install devel/kyua

RESULT_DB=$(ls /root/.kyua/store/results.usr_tests.*)
SQL="select * from test_results where result_type = 'failed';"

/usr/local/bin/sqlite3 "$RESULT_DB" "$SQL"
