#! /usr/bin/env bash
set -euxo pipefail

SELF="$(dirname "$(readlink -f "$0")")"
rm -rf   /tmp/archive
tar cf -                  \
  --exclude archive.tar   \
  --exclude .circleci     \
  --exclude-vcs           \
  --exclude-vcs-ignores . |
( mkdir -v /tmp/archive &&
  cd       /tmp/archive &&
  tar xf   - )
makeself --nocomp /tmp/archive archive.tar quine \
env RECP=InnovAnon-Inc@protonmail.com make -j$(nproc)
rm -rf   /tmp/archive
mkdir -v /tmp/archive
cd       /tmp/archive
"$SELF/archive.tar"

