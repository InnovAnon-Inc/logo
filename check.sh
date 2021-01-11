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
err=()
set +x
for k in "${files[@]}" ; do
  [[ -f "$k" ]] ||
  err=("${err[@]}" "$k")
  #err=$((err + 1))
done
printf "%s\n" "${files[@]}"
set -x
echo "${#files[@]}"
(( ! ${#err[@]} ))
#(( ! err ))

