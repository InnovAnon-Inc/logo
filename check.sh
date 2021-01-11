#! /usr/bin/env bash
set -euvxo pipefail
#(( UID ))
(( ! $# ))
cd out
mapfile -t files < <( "${0/.sh/.list}" )
err=0
for k in "${files[@]}" ; do
  [[ -f "$k" ]] ||
  err=$((err + 1))
done
echo "${#files[@]}"
(( ! err ))

