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
#TARCHIVE="$BLD/archive.tar"
TARCHIVE="$OUT/archive.tar"

#rm -rf   $ARCHIVE
# shellcheck disable=SC2064
trap "rm -rf $ARCHIVE" 0
rm -vf      "$TARCHIVE"

#pwd
#ls -ltra

  #--exclude-vcs-ignores   \
  #--exclude="$DLD"        \
#  --exclude-vcs           \
#  --exclude=README.md     \
#  --exclude=LICENSE       \
#  --exclude=.circleci     \
#  --exclude=.travis.yml   \
#  --exclude=.travis       \
#  --exclude=nohup.out     \
#  --exclude=Dockerfile    \
#  --exclude=Makefile.old  \
#  --exclude='*.swp'       \
#  --exclude='*.out'       \
#  --exclude="$OUT"        \
#  --exclude="$BLD"        \
#  --exclude="$STG"        \
#  --exclude="$TST"        \
#  --exclude=.dockerignore \
#  --exclude=.gitignore    \
#  --sparse . ) |
( tar cf -                \
  --absolute-names        \
  --group=nogroup         \
  --mtime=0               \
  --no-acls               \
  --numeric-owner         \
  --owner=nobody          \
  --sort=name             \
  --exclude="$DLD/.sentinel" \
  Makefile                \
  ./*.url                 \
  "$DLD/"               ) |
( #mkdir -v "$ARCHIVE" &&
  cd       "$ARCHIVE" &&
  tar xf   - )
# for stego:
#makeself --nocomp "$ARCHIVE" "$TARCHIVE" quine  \
# shellcheck disable=SC2086
makeself --xz --complevel 9e "$ARCHIVE" "$TARCHIVE" quine  \
env "LOL=$LOL"  "PW=$PW" "RECP=$RECP" "DLD=$DLD" \
    "OUT=$OUT" "BLD=$BLD" "STG=$STG"  "TST=$TST" \
$MAKE dist
#env "LOL=$LOL" $MAKE release
#env LOL=0 $MAKE release
#env RECP=InnovAnon-Inc@protonmail.com make -j$(nproc) release
#make -j$(nproc)
#rm -rf   "$ARCHIVE"
#mkdir -v /tmp/archive
#cd       /tmp/archive
#"$SELF/archive.tar"

