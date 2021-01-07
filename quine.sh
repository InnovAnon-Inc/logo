#! /usr/bin/env bash
set -euxo pipefail

#SELF="$(dirname "$(readlink -f "$0")")"
#[[ -n "${MAKE:-}" ]] ||
#MAKE="make -j$(nproc)"

MAKE="${MAKE:-make -j$(nproc)}"

rm -rf   /tmp/archive
trap 'rm -rf /tmp/archive' 0
rm -vf      ./archive.tar
tar cf -                  \
  --exclude=archive.tar   \
  --exclude=.circleci     \
  --exclude=LICENSE       \
  --exclude=README.md     \
  --exclude-vcs           \
  --exclude-vcs-ignores   \
  --absolute-names        \
  --group=nogroup         \
  --mtime=0               \
  --no-acls               \
  --numeric-owner         \
  --owner=nobody          \
  --sort=name             \
  --sparse              . |
( mkdir -v /tmp/archive &&
  cd       /tmp/archive &&
  tar xf   - )
# shellcheck disable=SC2086
makeself --nocomp /tmp/archive archive.tar quine \
env "LOL=$LOL" $MAKE dist
#env "LOL=$LOL" $MAKE release
#env LOL=0 $MAKE release
#env RECP=InnovAnon-Inc@protonmail.com make -j$(nproc) release
#make -j$(nproc)
rm -rf   /tmp/archive
#mkdir -v /tmp/archive
#cd       /tmp/archive
#"$SELF/archive.tar"

