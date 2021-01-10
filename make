#! /bin/bash
set -euo pipefail
export SOCKS_PROXY="${SOCKS_PROXY:-socks5://127.0.0.1:9050}"
PATH=.:$PATH \
. support.sh
$MAKE -f .Makefile "$@"

