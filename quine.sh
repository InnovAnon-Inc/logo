#! /usr/bin/env bash
set -euxo pipefail

#SELF="$(dirname "$(readlink -f "$0")")"
#[[ -n "${MAKE:-}" ]] ||
#MAKE="make -j$(nproc)"

MAKE="${MAKE:-make -j$(nproc)}"

ARCHIVE="$(mktemp -d)"
#TARCHIVE="$(mktemp XXXXXXXX.tar)"
TARCHIVE=archive.tar

#rm -rf   $ARCHIVE
# shellcheck disable=SC2064
trap "rm -rf $ARCHIVE" 0
rm -vf      "$TARCHIVE"
  #--exclude-vcs-ignores   \
tar cf -                  \
  --exclude="$TARCHIVE"   \
  --exclude=.circleci     \
  --exclude=LICENSE       \
  --exclude=README.md     \
  --exclude='*.png'       \
  --exclude='*.jpg'       \
  --exclude='*.dim'       \
  --exclude-vcs           \
  --absolute-names        \
  --group=nogroup         \
  --mtime=0               \
  --no-acls               \
  --numeric-owner         \
  --owner=nobody          \
  --sort=name             \
  --sparse              . |
( #mkdir -v "$ARCHIVE" &&
  cd       "$ARCHIVE" &&
  tar xf   - )
# shellcheck disable=SC2086
makeself --nocomp "$ARCHIVE" "$TARCHIVE" quine \
env "LOL=$LOL" $MAKE dist
#env "LOL=$LOL" $MAKE release
#env LOL=0 $MAKE release
#env RECP=InnovAnon-Inc@protonmail.com make -j$(nproc) release
#make -j$(nproc)
rm -rf   "$ARCHIVE"
#mkdir -v /tmp/archive
#cd       /tmp/archive
#"$SELF/archive.tar"

