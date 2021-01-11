#! /usr/bin/env bash
set -euvxo pipefail
#(( UID ))
(( ! $# ))
SELF="$(readlink -f "$0")"
LIST="${SELF/.sh/.list}"
cd out
[[ -x "$LIST" ]]
mapfile -t files < <( "$LIST" )
(( ${#files[@]} ))
err=0
for k in "${files[@]}" ; do
  [[ -f "$k" ]] ||
  err=$((err + 1))
done
echo "${#files[@]}"
(( ! err ))

