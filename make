#! /bin/bash
set -euo pipefail
PATH=.:$PATH \
. support.sh
$MAKE -f .Makefile "$@"

