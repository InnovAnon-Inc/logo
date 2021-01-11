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
  [[ -n "$k" ]] || continue # trailing newline ?
  [[ -f "$k" ]] ||
  err=("${err[@]}" "$k")
  #err=$((err + 1))
done
set -x
echo total files: "${#files[@]}"
echo error files:
printf %s\\n "${err[@]}"
(( ! ${#err[@]} ))
#(( ! err ))

