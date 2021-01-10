#! /bin/sh
set -eux
find . \! -type d    |
xargs -P$(nproc) -n1 \
gpg --sign %         \

