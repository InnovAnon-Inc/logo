#! /bin/bash
set -euvxo pipefail
(( ! $# ))
#(( UID ))
find . -print0 \
  \! -type d   |
xargs -I% -t   \
  "-P$(nproc)" \
gpg --sign %

