#! /bin/bash
set -euvxo pipefail
(( ! $# ))
#(( UID ))
find . -print0 \
  \! -type d   |
xargs -0       \
  -I% -t       \
  "-P$(nproc)" \
gpg --sign %

