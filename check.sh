#! /usr/bin/env bash
set -euvxo pipefail
#(( UID ))
(( ! $# ))
cd out
SELF="$(readlink -f "$0")"
mapfile -t files < <( "${SELF/.sh/.list}" )
err=0
for k in "${files[@]}" ; do
  [[ -f "$k" ]] ||
  err=$((err + 1))
done
echo "${#files[@]}"
(( ! err ))

