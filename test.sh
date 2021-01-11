#! /usr/bin/env bash
set -euvxo pipefail
#(( UID ))
(( $# == 1 ))
TARCHIVE="$1"
[[ -x "$TARCHIVE" ]]

#LOL="${LOL:-0}"
#LOL="${LOL:-1}"

#RECP="${RECP:-}"
#RECP="${RECP:---encrypt -r $(RECP)}"

#STEGEXT="${STEGEXT:-ppm}"
STEGEXT="${STEGEXT:-bmp}"

#PW="${PW:-InnovAnon}"

if (( ! LOL )) ; then
  OUT="${OUT:-/tmp/out}"
  STG="${STG:-/tmp/stg}"
fi

"$TARCHIVE"

