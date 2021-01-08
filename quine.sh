#! /usr/bin/env bash
set -euxo pipefail

#SELF="$(dirname "$(readlink -f "$0")")"
#[[ -n "${MAKE:-}" ]] ||
#MAKE="make -j$(nproc)"

MAKE="${MAKE:-make -j$(nproc)}"
OUT="${OUT:-out}"
DLD="${DLD:-dld}"
BLD="${BLD:-bld}"
STG="${STG:-stg}"
TST="${TST:-tst}"
PW="${PW:-}"
RECP="${RECP:-}"

ARCHIVE="$(mktemp -d)"
#TARCHIVE="$(mktemp XXXXXXXX.tar)"
TARCHIVE="$BLD/archive.tar"

#rm -rf   $ARCHIVE
# shellcheck disable=SC2064
trap "rm -rf $ARCHIVE" 0
rm -vf      "$TARCHIVE"

#pwd
#ls -ltra

  #--exclude-vcs-ignores   \
( tar cf -                \
  --exclude-vcs           \
  --exclude=README.md     \
  --exclude=LICENSE       \
  --exclude=.circleci     \
  --exclude=.travis.yml   \
  --exclude=.travis       \
  --exclude=nohup.out     \
  --exclude=Dockerfile    \
  --exclude='*.swp'       \
  --exclude='*.out'       \
  --exclude="$OUT"        \
  --exclude="$DLD"        \
  --exclude="$BLD"        \
  --exclude="$STG"        \
  --exclude="$TST"        \
  --absolute-names        \
  --group=nogroup         \
  --mtime=0               \
  --no-acls               \
  --numeric-owner         \
  --owner=nobody          \
  --sort=name             \
  --sparse            . ) |
( #mkdir -v "$ARCHIVE" &&
  cd       "$ARCHIVE" &&
  tar xf   - )
# shellcheck disable=SC2086
makeself --nocomp "$ARCHIVE" "$TARCHIVE" quine  \
env "LOL=$LOL" "PW=$PW" "RECP=$RECP" "DLD=$DLD" \
    "OUT=$OUT" "BLD=$BLD" "STG=$STG" "TST=$TST" \
$MAKE dist
#env "LOL=$LOL" $MAKE release
#env LOL=0 $MAKE release
#env RECP=InnovAnon-Inc@protonmail.com make -j$(nproc) release
#make -j$(nproc)
#rm -rf   "$ARCHIVE"
#mkdir -v /tmp/archive
#cd       /tmp/archive
#"$SELF/archive.tar"

