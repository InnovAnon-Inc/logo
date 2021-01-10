#! /usr/bin/env bash
set -euvxo pipefail

MAKE="${MAKE:-make -j$(nproc)}"
OUT="${OUT:-out}"
DLD="${DLD:-dld}"
BLD="${BLD:-bld}"
STG="${STG:-stg}"
TST="${TST:-tst}"
PW="${PW:-}"
RECP="${RECP:-}"

ARCHIVE="$(mktemp -d)"
#TARCHIVE="$OUT/archive.tar"

# shellcheck disable=SC2064
trap "rm -rf $ARCHIVE" 0
# shellcheck disable=SC2153
rm -vf      "$TARCHIVE"

( tar cf -                \
  --absolute-names        \
  --group=nogroup         \
  --mtime=0               \
  --no-acls               \
  --numeric-owner         \
  --owner=nobody          \
  --sort=name             \
  --sparse                \
  --exclude="$DLD/.sentinel" \
  Makefile                \
  ./*.url                 \
  "$0"                    \
  "$DLD/"               ) |
( cd       "$ARCHIVE" &&
  tar xf   - )
# shellcheck disable=SC2153
case "$TARCHIVE" in
  $OUT/*.tar)
    # shellcheck disable=SC2086
    makeself --xz --complevel 9e "$ARCHIVE" "$TARCHIVE" quine  \
    env "LOL=$LOL"  "PW=$PW" "RECP=$RECP" "DLD=$DLD"           \
        "OUT=$OUT" "BLD=$BLD" "STG=$STG"  "TST=$TST"           \
    $MAKE dist
    ;;
  $STG/*.tar)
    # shellcheck disable=SC2086
    makeself --nocomp "$ARCHIVE" "$TARCHIVE" quine   \
    env "LOL=$LOL"  "PW=$PW" "RECP=$RECP" "DLD=$DLD" \
        "OUT=$OUT" "BLD=$BLD" "STG=$STG"  "TST=$TST" \
    $MAKE dist
    ;;
  *) exit 1 ;;
esac

